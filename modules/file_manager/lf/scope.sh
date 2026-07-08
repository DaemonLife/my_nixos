#!/usr/bin/env bash
# lf previewer script
#
# lf's previewer interface:
#   $1  file path
#   $2  width       (columns of the preview pane)
#   $3  height      (lines of the preview pane)
#   $4  x position  (horizontal offset of the preview pane)
#   $5  y position  (vertical offset of the preview pane)
#   $6  mode        ("preview" or "preload" when the preload option is enabled)
#
# Exit codes:
#   0           Output is cached by lf. The previewer will not be called again
#               for this file until lf decides the cache is stale.
#   non-zero    Output is not cached. The previewer is called again every time
#               the file is selected.
#

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="${1}"     # Full path of the highlighted file
PV_WIDTH="${2:-80}"  # Width of the preview pane (columns); default 80
PV_HEIGHT="${3:-40}" # Height of the preview pane (lines);  default 40
# $4 x position, $5 y position, $6 mode — unused here

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

## Settings
HIGHLIGHT_SIZE_MAX=262143 # 256 KiB; larger files fall back to plain text
HIGHLIGHT_TABWIDTH="${HIGHLIGHT_TABWIDTH:-8}"
HIGHLIGHT_STYLE="${HIGHLIGHT_STYLE:-pablo}"
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE="${PYGMENTIZE_STYLE:-autumn}"
BAT_STYLE="${BAT_STYLE:-plain}"

SQLITE_TABLE_LIMIT=20 # top N tables shown; 0 = only show sqlite_master
SQLITE_ROW_LIMIT=5    # first + last N-1 rows per table; 0 = no limit

# unset the SIXEL variable to disable image preview
SIXEL=true

# ---------------------------------------------------------------------------
# handle_extension — file-extension-based dispatch
# ---------------------------------------------------------------------------
handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in

  ## Archives
  a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
    rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
    atool --list -- "${FILE_PATH}" && exit 0
    bsdtar --list --file "${FILE_PATH}" && exit 0
    exit 1
    ;;

  rar)
    ## Avoid password prompt by providing empty password
    unrar lt -p- -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  7z)
    ## Avoid password prompt by providing empty password
    7zz l -p -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## PDF — text conversion
  pdf)
    pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
      fmt -w "${PV_WIDTH}" && exit 0
    mutool draw -F txt -i -- "${FILE_PATH}" 1-10 |
      fmt -w "${PV_WIDTH}" && exit 0
    exiftool "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## BitTorrent
  torrent)
    transmission-show -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## OpenDocument
  odt | sxw)
    odt2txt "${FILE_PATH}" && exit 0
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ods | odp)
    odt2txt "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## XLSX
  xlsx)
    xlsx2csv -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## HTML
  htm | html | xhtml)
    w3m -dump "${FILE_PATH}" && exit 0
    lynx -dump -- "${FILE_PATH}" && exit 0
    elinks -dump "${FILE_PATH}" && exit 0
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
    ;;

  ## JSON
  json)
    jq --color-output . "${FILE_PATH}" && exit 0
    python -m json.tool -- "${FILE_PATH}" && exit 0
    ;;

  ## Jupyter Notebooks
  ipynb)
    jupyter nbconvert --to markdown "${FILE_PATH}" --stdout |
      bat --color=always --strip-ansi=always --style=plain \
        --language=markdown && exit 0
    jupyter nbconvert --to markdown "${FILE_PATH}" --stdout && exit 0
    jq --color-output . "${FILE_PATH}" && exit 0
    python -m json.tool -- "${FILE_PATH}" && exit 0
    ;;

  ## Audio formats not reliably detected by file(1)
  dff | dsf | wv | wvc)
    mediainfo "${FILE_PATH}" && exit 0
    exiftool "${FILE_PATH}" && exit 0
    ;;

  esac
}

# ---------------------------------------------------------------------------
# handle_mime — MIME-type-based dispatch
# ---------------------------------------------------------------------------
handle_mime() {
  local MIMETYPE="${1}"

  case "${MIMETYPE}" in

  ## RTF and DOC
  text/rtf | *msword)
    catdoc -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## DOCX, ePub, FB2
  *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## E-mail
  message/rfc822)
    mu view -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## XLS
  *ms-excel)
    xls2csv -- "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## SQLite
  *sqlite3)
    SQLITE_TABLES="$(sqlite3 "file:${FILE_PATH}?mode=ro" '.tables')" ||
      exit 1
    [ -z "${SQLITE_TABLES}" ] && { echo "Empty SQLite database." && exit 0; }

    sqlite_show_query() {
      sqlite-utils query "${FILE_PATH}" "${1}" --table --fmt fancy_grid ||
        sqlite3 "file:${FILE_PATH}?mode=ro" "${1}" -header -column
    }

    SQLITE_ROWCOUNT_QUERY="$(
      sqlite3 "file:${FILE_PATH}?mode=ro" -noheader \
        'SELECT group_concat(
                        "SELECT """ || name || """ AS tblname,
                        count(*) AS rowcount
                        FROM " || name,
                        " UNION ALL "
                    )
                    FROM sqlite_master
                    WHERE type="table" AND name NOT LIKE "sqlite_%";'
    )"
    sqlite_show_query \
      "SELECT tblname AS 'table', rowcount AS 'count',
                    (
                        SELECT '(' || group_concat(name, ', ') || ')'
                        FROM pragma_table_info(tblname)
                    ) AS 'columns',
                    (
                        SELECT '(' || group_concat(
                            upper(type) || (
                                CASE WHEN pk > 0 THEN ' PRIMARY KEY' ELSE '' END
                            ),
                            ', '
                        ) || ')'
                        FROM pragma_table_info(tblname)
                    ) AS 'types'
                FROM (${SQLITE_ROWCOUNT_QUERY});"

    if [ "${SQLITE_TABLE_LIMIT}" -gt 0 ] &&
      [ "${SQLITE_ROW_LIMIT}" -ge 0 ]; then

      echo && printf '>%.0s' $(seq "${PV_WIDTH}") && echo

      sqlite3 "file:${FILE_PATH}?mode=ro" -noheader \
        "SELECT name FROM sqlite_master
                     WHERE type='table' AND name NOT LIKE 'sqlite_%'
                     LIMIT ${SQLITE_TABLE_LIMIT};" |
        while read -r SQLITE_TABLE; do
          SQLITE_ROWCOUNT="$(
            sqlite3 "file:${FILE_PATH}?mode=ro" -noheader \
              "SELECT count(*) FROM ${SQLITE_TABLE}"
          )"
          echo

          if [ "${SQLITE_ROW_LIMIT}" -gt 0 ] &&
            [ "${SQLITE_ROW_LIMIT}" -lt "${SQLITE_ROWCOUNT}" ]; then

            echo "${SQLITE_TABLE} [${SQLITE_ROW_LIMIT} of ${SQLITE_ROWCOUNT}]:"

            SQLITE_ELLIPSIS_QUERY="$(
              sqlite3 "file:${FILE_PATH}?mode=ro" -noheader \
                "SELECT 'SELECT ' || group_concat(
                                    '''...''', ', '
                                )
                                FROM pragma_table_info('${SQLITE_TABLE}');"
            )"

            sqlite_show_query \
              "SELECT * FROM (
                                SELECT * FROM ${SQLITE_TABLE} LIMIT 1
                            )
                            UNION ALL ${SQLITE_ELLIPSIS_QUERY} UNION ALL
                            SELECT * FROM (
                                SELECT * FROM ${SQLITE_TABLE}
                                LIMIT (${SQLITE_ROW_LIMIT} - 1)
                                OFFSET (
                                    ${SQLITE_ROWCOUNT}
                                    - (${SQLITE_ROW_LIMIT} - 1)
                                )
                            );"
          else
            echo "${SQLITE_TABLE} [${SQLITE_ROWCOUNT}]:"
            sqlite_show_query "SELECT * FROM ${SQLITE_TABLE};"
          fi
        done
    fi

    exit 0
    ;;

  ## Plain text and XML — syntax-highlighted
  text/* | */xml)
    if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
      ## File too large for highlighting — let lf display it raw
      exit 2
    fi

    if [[ "$(tput colors)" -ge 256 ]]; then
      local PYGMENTIZE_FORMAT='terminal256'
      local HIGHLIGHT_FORMAT='xterm256'
    else
      local PYGMENTIZE_FORMAT='terminal'
      local HIGHLIGHT_FORMAT='ansi'
    fi

    ## highlight may not respond to SIGPIPE gracefully; '|| true'
    ## ensures exit 0 so lf can cache the partial output.
    env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight \
      --out-format="${HIGHLIGHT_FORMAT}" \
      --force -- "${FILE_PATH}" || true && exit 0

    bat --color=always --strip-ansi=always --style="${BAT_STYLE}" \
      -- "${FILE_PATH}" || true && exit 0

    ## pygmentize may not respond to SIGPIPE gracefully; '|| true'
    ## ensures exit 0 so lf can cache the partial output.
    pygmentize -f "${PYGMENTIZE_FORMAT}" \
      -O "style=${PYGMENTIZE_STYLE}" \
      -- "${FILE_PATH}" || true && exit 0

    exit 2
    ;;

  ## DjVu — text conversion
  image/vnd.djvu)
    djvutxt "${FILE_PATH}" | fmt -w "${PV_WIDTH}" && exit 0
    exiftool "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## The previewer shows metadata by default, but will render the image if $SIXEL is true.
  image/*)
    if [ $SIXEL ]; then
      chafa -f sixel -s "$PV_WIDTH"x"$PV_HEIGHT" --animate off --polite on "${FILE_PATH}" && exit 0
    fi
    exiftool "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## Video and audio
  video/* | audio/*)
    mediainfo "${FILE_PATH}" && exit 0
    exiftool "${FILE_PATH}" && exit 0
    exit 1
    ;;

  ## ELF binaries and shared objects
  application/x-executable | application/x-pie-executable | application/x-sharedlib)
    readelf -WCa "${FILE_PATH}" && exit 0
    exit 1
    ;;

  esac
}

handle_fallback() {
  echo '----- File Type Classification -----'
  file --dereference --brief -- "${FILE_PATH}" && exit 0
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
