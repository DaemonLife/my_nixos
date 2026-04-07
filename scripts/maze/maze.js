maze(50,22);

function maze(width, height){
  var walls = [];
  for(var i=0;i<width;i++){
    walls.push([]);
    for(var j=0;j<height;j++){
      walls[i].push([1,1,1,1])
      if(i==0){walls[i][j][3]=0}
      if(i==width-1){walls[i][j][1]=0}
      if(j==0){walls[i][j][0]=0}
      if(j==height-1){walls[i][j][2]=0}
    }
  }
  walls[0][0][2]=0;
  walls[0][1][0]=0;
  walls[width-1][height-1][0]=0;
  walls[width-1][height-2][2]=0;

  var cells = [];
  for(var i=0;i<walls.length-1;i++){
    cells.push([]);
    for(var j=0;j<walls[i].length-1;j++){
      cells[i].push(false)
    }
  }

  makeMaze(walls, cells, 0,0);
  var output = getMazeString(walls)

  console.log(output);
  return output;
}


function shuffle(a) {
    var j, x, i;
    for (i = a.length - 1; i > 0; i--) {
        j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
    return a;
}

function makeMaze(walls, cells, x, y){
  cells[x][y] = true;
  var order = shuffle([0,1,2,3])
  var functions = [
    function(){
      if(x>0){
        if(!cells[x-1][y]){
          walls[x][y][2]=0;
          walls[x][y+1][0]=0;
          makeMaze(walls,cells,x-1,y);
        }
      }
    },
    function(){
      if(x<cells.length-1){
        if(!cells[x+1][y]){
          walls[x+1][y][2]=0;
          walls[x+1][y+1][0]=0;
          makeMaze(walls,cells,x+1,y);
        }
      }
    },
    function(){
      if(y>0){
        if(!cells[x][y-1]){
          walls[x][y][1]=0;
          walls[x+1][y][3]=0;
          makeMaze(walls,cells,x,y-1);
        }
      }
    },
    function(){
      if(y<cells[0].length-1){
        if(!cells[x][y+1]){
          walls[x][y+1][1]=0;
          walls[x+1][y+1][3]=0;
          makeMaze(walls,cells,x,y+1);
        }
      }
    }
  ]
  functions[order[0]]();
  functions[order[1]]();
  functions[order[2]]();
  functions[order[3]]();
}

function getWallType(type){
  //0 = top wall
  //1 = right wall
  //2 = down wall
  //3 = left wall
  var wallChars = [[[[[" "],["╸"]],[["╻"],["┓"]]],[[["╺"],["━"]],[["┏"],["┳"]]]],[[[["╹"],["┛"]],[["┃"],["┫"]]],[[["┗"],["┻"]],[["┣"],["╋"]]]]]
  return wallChars[type[0]][type[1]][type[2]][type[3]]
}

function getMazeString(walls){
  var output = "";
  for(var i=0;i<walls[0].length;i++){
    for(var j=0;j<walls.length;j++){
      output+=getWallType(walls[j][i]);
      if(j<walls.length-1){
        if(walls[j][i][1]){
          output+="━";
        }else{
          output+=" ";
        }
      }
    }
    output+="\n";
  }
  return output;
}
