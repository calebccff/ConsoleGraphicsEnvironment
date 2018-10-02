module cge.graphics;

import std.stdio;
import core.thread;
import std.process;
import std.conv;
import std.string;

int frameRate = 99999999;
int width;
int height;

abstract class Canvas{

  this(){
    string size = execute(["stty", "size"]).output;
    int w = to!int(size[0 .. indexOf(size, ' ')]);
    int h = to!int(size[indexOf(size, ' ')+1 .. size.length-1]);
    writeln(w, " - ", h);
    width = h;
    height = w;
  }


  this(int w, int h){
    width = w;
    height = h;
  }

  abstract void setup(){

  }

  abstract void draw(){
    //To be overwritten
  }

  void start(){
    background();
    setup();
    for(int count = 0;;count++){
      draw();
      gotoPos(0, 0);
      stdout.flush();
      Thread.sleep(dur!("msecs")(1000/frameRate));
    }
  }
}

void point(float x, float y, string c){
  gotoPos(to!int(x), to!int(y));
  writef(c);
}

void rect(int x, int y, int w, int h){
  for(int i = x; i < x+w; i++){
    for(int j = y; j < y+h; j++){
      gotoPos(i, j);
      writef("#");
    }
  }
  //stdout.flush();
}

void text(string str, int x, int y){ //X > 0 if string includes \n it goes to beggining of line
  gotoPos(x, y);
  writef(str);
}

void background(){
  gotoPos(0, 0);
  for(int i = 0; i < height; i++){
    if(i > 0){
      writef("\n");
    }
    for(int j = 0; j < width; j++){
      writef(" ");
    }
  }
  //stdout.flush();
}

void gotoPos(int x, int y){ //Set cursor position
  printf("\033[%d;%dH", (y), (x));
}
