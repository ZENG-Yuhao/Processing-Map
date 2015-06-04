//unfolding map
import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.SimplePointMarker;
import de.fhpotsdam.unfolding.marker.*;
de.fhpotsdam.unfolding.Map map;
//WindowClass
import controlP5.*;
ControlWindowClass a;
int handleMax, handleMin;
int [] datas, wdatas, mdatas;
String [] tags, wtags, mtags;

//file input
String[] lines;
int[] marks, wmarks, mmarks;
int pmarks, wpmarks, mpmarks, weekBegin, monthBegin;
String[] dates;
String temp1,temp2;
DropdownList dpd;
int item;
public void setup(){
//unfolding map
size(800, 600, GLConstants.GLGRAPHICS);
  noStroke();
  map = new de.fhpotsdam.unfolding.Map(this);
  map.setTweening(true);
  map.zoomToLevel(13);
  map.panTo(new Location(48.8571,2.3491528));
  MapUtils.createDefaultEventDispatcher(this, map);
  
//files input
             lines = loadStrings("D:\\data\\geo\\geos1.txt");
             marks = new int[lines.length];
             wmarks = new int[lines.length];
             mmarks = new int[lines.length];
             tags = new String[lines.length];
             wtags = new String[lines.length];
             mtags = new String[lines.length];
             datas = new int[lines.length];
             wdatas = new int[lines.length];
             mdatas = new int[lines.length];
             
             for (int i = 0; i < lines.length; i++) {
                 if (lines[i].equals("010101")){
                     marks[pmarks] = i;
                     pmarks++;   
                 }  
             }//end for
             
             wmarks[0] = 0;   mmarks[0] = 0;
             marks[pmarks] = lines.length;
             weekBegin = 0;    monthBegin = 0;
             wpmarks = 0;  mpmarks = 0;
             for (int i = 0;  i<= pmarks-1; i++){
                 datas[i] = (marks[i+1] - marks[i] -1) /3;
                 tags[i] = lines[marks[i]+1];
                 if ((i+1) % 7 == 0 ){
                     wdatas[wpmarks] = 0;
                     for (int j=weekBegin; j<=i; j++)   
                          wdatas[wpmarks] = wdatas[wpmarks] + datas[j];
                     
                     wmarks[wpmarks+1] =  i;     
                     wtags[wpmarks] = lines[marks[weekBegin]+1].substring(5,10) + "___" + lines[marks[i]+1].substring(5,10); 
                     weekBegin = i+1;     wpmarks++;     
                 } 
                 if (i<pmarks - 1){
                 temp1 = lines[marks[i] + 1].substring(0,7);
                 temp2 = lines[marks[i+1] + 1].substring(0,7);
                 println("temp1: " + temp1 + "  temp2: " + temp2);
                 if (!temp1.equals(temp2)){
                    
                     mdatas[mpmarks] = 0;
                     for (int j=monthBegin; j<=i; j++)   
                         mdatas[mpmarks] = mdatas[mpmarks] + datas[j]; 
                     
                     mmarks[mpmarks+1] = i;
                     mtags[mpmarks] = lines[marks[monthBegin]+1].substring(5,10) + "___" + lines[marks[i]+1].substring(5,10);
                     monthBegin = i+1;    mpmarks++;
                 }
                 }
               
                 if (i== pmarks-1){
                      if (weekBegin != pmarks){
                         wdatas[wpmarks] = 0;
                         for (int j=weekBegin; j<=i; j++)   
                             wdatas[wpmarks] = wdatas[wpmarks] + datas[j];
                          
                         wmarks[wpmarks+1] = i;
                         wtags[wpmarks] = lines[marks[weekBegin]+1].substring(5,10) + "___" + lines[marks[i]+1].substring(5,10); 
                         wpmarks++;
                      }
                      if (monthBegin != mpmarks){
                         mdatas[mpmarks] = 0;
                         for (int j=monthBegin; j<=i; j++)
                             mdatas[mpmarks] = mdatas[mpmarks] + datas[j];
                          
                          mmarks[mpmarks+1] = i;   
                          mtags[mpmarks] = lines[marks[monthBegin]+1].substring(5,10) + "___" + lines[marks[i]+1].substring(5,10);
                          mpmarks++;
                      }
                 }
             }//end for
 
a= new ControlWindowClass(this);

a.setDatas(datas);
a.setTags(tags);

a.setSeekBarRange(0,pmarks)
 .setSize(700,800)
 .setCanvasSize(640,780)
 .setFont(createFont("Calibri",15));
a.create(this);
//dropdownlist
dpd = a.addDropdownList("Type")
         .setPosition(300, 80)
         .moveTo(a.controlWindow);
  dpd.setBackgroundColor(color(190));
  dpd.setItemHeight(25);
  dpd.setBarHeight(20);
  dpd.captionLabel().set("dropdown");
  dpd.captionLabel().style().marginTop = 3;
  dpd.captionLabel().style().marginLeft = 3;
  dpd.valueLabel().style().marginTop = 3;
      dpd.addItem("1. day ", 1);
      dpd.addItem("2. week ", 2);
      dpd.addItem("3. month ", 3);
  dpd.setColorBackground(color(60));
  dpd.setColorActive(color(255, 128));
  dpd.setIndex(0); 
}
public void draw(){
    background(0);
    map.draw();
    
    //four places popular
       Location locationGeos;
       ScreenPosition posGeos;
    int pMin, pMax, start, intvl;
    for (int index = handleMin; index <= handleMax; index++){
        start=index; intvl=1;
        switch (item){
            case 1:
                   start = index;
                   intvl = 1;
                   break;
            case 2:
                   start = wmarks[index];
                   intvl = 7;
                   break;
            case 3:
                   start = mmarks[index];
                   intvl = mmarks[index+1] - mmarks[index] + 1;
                   break;
        }// end switch
        float h,l;
        pMax = marks[start];
        for (int d = 1; d <= intvl; d++){
            pMin = pMax + 3;   pMax = marks[start + d];
            for (int i = pMin; i <= pMax-1; i=i+3){
                h=float(lines[i]);
                l=float(lines[i+1]);
                locationGeos = new Location(h, l);
                posGeos = map.getScreenPosition(locationGeos);
                fill(0, 102, 153, 204);
                ellipse(posGeos.x, posGeos.y, 5, 5);
            }//end for i
        }// end for d
    }
locationGeos =new Location(48.858204,2.2944973);
       posGeos = map.getScreenPosition(locationGeos);
       fill(255,0,0);
       ellipse(posGeos.x, posGeos.y, 10,10);
  
       locationGeos =new Location(48.874107,2.2951834);
       posGeos = map.getScreenPosition(locationGeos);
       fill(255,0,0);
       ellipse(posGeos.x, posGeos.y, 10,10);
  
       locationGeos =new Location(48.85316,2.3491528);
       posGeos = map.getScreenPosition(locationGeos);
       fill(255,0,0);
       ellipse(posGeos.x, posGeos.y, 10,10);
  
       locationGeos =new Location(48.86104,2.3359056);
       posGeos = map.getScreenPosition(locationGeos);
       fill(255,0,0);
       ellipse(posGeos.x, posGeos.y, 10,10);
}


public class ControlWindowClass extends ControlP5{
      //ControlP5 cp5;
      ControlWindow controlWindow;
      Range rangeSeekBar;
      MyCanvas canv;
      //public static int handleMax, handleMin;
      int[] datas;
      //int[] intervals;
      String[] tags;
      boolean dataDone = false;
      int windowHeight, windowWidth, windowX, windowY;
      float canvHeight, canvWidth, canvOx, canvOy;
      int skbarHeight, skbarWidth, skbarX, skbarY, skbarHandleSize;
      int skbarRange0, skbarRange1;
      {
          windowX = 10;   windowY = 10;
          windowHeight = 720;  windowWidth = 420;
          canvHeight = 660;    canvWidth = 400;
          canvOy = 50;   canvOx = 10;
          skbarHeight = 30;  skbarWidth = 400;
          skbarX = 10; skbarY= 10;
          skbarHandleSize = 5;
          skbarRange0 = 0;   skbarRange1 = 7;
      }
      //constructor
      public ControlWindowClass(PApplet applet){
          super(applet);
      }
      
      public void setDatas(int[] datas){
          this.datas = datas;
          dataDone = true;
      }
      public void setTags(String[] tags){
          //if ( dataDone && (datas.length == tags.length) )
             this.tags =tags;
      }
     
      public ControlWindowClass setSize(int h, int w){
          this.windowHeight = h;   this.windowWidth = w;
          return this;
      }
      public ControlWindowClass setPos(int x, int y){
          this.windowX = x;   this.windowY = y;
          return this;
      }
      public ControlWindowClass setCanvasSize(float h, float w){
          canvHeight = h;    canvWidth = w;
          return this;
      }
      public ControlWindowClass setCanvasOxOy(float x, float y){
          canvOx = x;      canvOy = y;
          return this;
      }
      public ControlWindowClass setSeekBarPos(int x, int y){
          skbarX = x; skbarY = y;
          return this;
      }
      public ControlWindowClass setSeekBarSize(int h, int w){
          skbarHeight = h;    skbarWidth = w;
          return this;
      }  
      public ControlWindowClass setSeekBarHandleSize(int s){
          skbarHandleSize = s; 
          return this;
      }
      public ControlWindowClass setSeekBarRange(int a, int b){
          skbarRange0 = a;   skbarRange1 = b;
          //rangeSeekBar.setRange(skbarRange0, skbarRange1);
          return this;
      }
      public ControlWindowClass changeSeekBarRange(int a, int b){
          rangeSeekBar.setRange(a, b);
          return this;
      }
      public void create(PApplet applet){
          //cp5 = new ControlP5(applet);
          controlWindow = this.addControlWindow("Settings and Graphic",windowX,windowY,windowWidth,windowHeight)
                              .hideCoordinates()
                              .setBackground(color(40)); 
          controlWindow.setUndecorated(false);
           
          rangeSeekBar = this.addRange("Date Controller")
                     .setBroadcast(false) 
                     .setPosition(skbarX,skbarY)
                     .setSize(skbarWidth,skbarHeight)
                     .setHandleSize(skbarHandleSize)
                     .setRange(skbarRange0,skbarRange1)
                     .setRangeValues(0,1)
                     // after the initialization we turn broadcast back on again
                     .setBroadcast(true)
                     .setColorForeground(color(255,40))
                     .setColorBackground(color(255,40))
                     .setColorValueLabel(color(70))
                     .moveTo(controlWindow);
              
          canv = new MyCanvas();
          canv.pre();
          controlWindow.addCanvas(canv);
      }//end void create

      
  class MyCanvas extends Canvas{
      float ox, oy, oheight, owidth;
      float ix, iy, singleWidth, originX, proportion;  
      int npeople, ndata, maxValue, minValue;
      public void setup (PApplet theApplet){
 
          oheight = canvHeight;
          owidth = canvWidth;
          ox = canvOx;
          oy = canvOy;
      }
  
      public void draw(PApplet p){
          maxValue =0;    minValue = 5000000;
          for (int i=0; i<=skbarRange1-1; i++){
              if (datas[i]> maxValue)  
                  maxValue = datas[i];
              if (datas[i] < minValue)
                  minValue = datas[i];
          }
          println(minValue);
          proportion = (canvHeight-100)/(maxValue - minValue);  
          
          p.rect(ox,oy,5,5);
          int ndata = handleMax - handleMin + 1;
          singleWidth = owidth / ndata;
          if ( singleWidth>= 20) {
              singleWidth = 20;
              originX = (owidth - ndata * singleWidth) / 2 + ox;   
          } else { originX = ox; }
          
          ix = originX - singleWidth;
          int save_i=0;
          float save_iy=0;
          boolean mouseE=false;
          for (int i = handleMin; i <= handleMax; i++){
              ix = ix + singleWidth;
              iy = oy+oheight - (datas[i] - minValue) * proportion - 50;
              p.fill(0, 102, 153, 204);
              p.rect(ix, iy, singleWidth, (datas[i] - minValue)*proportion + 50);
              if (p.mouseX>=ix && p.mouseX<ix+singleWidth && p.mouseY>=iy && p.mouseY<oy+oheight){
                     save_i = i;
                     save_iy = iy;
                     mouseE = true;
              } 
          }//end for
              if (mouseE){
                     p.fill(255,0,0);
                     p.rect(ox, save_iy, owidth, 1);
                     p.text(tags[save_i],ox, save_iy-5);
                     int temp=datas[save_i], len = 1;
                     while (temp / 10 != 0){
                         temp = temp /10;
                         len++;
                     }
                     p.text(datas[save_i],ox+owidth-len*7, save_iy-5);
              }
      }//end draw
  }//end class MyCanvas


     

}//end ControlWindowClass

 void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isFrom("Date Controller")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    
    handleMin = int (theControlEvent.getController().getArrayValue(0));
    handleMax =handleMin + int(theControlEvent.getController().getArrayValue(1)
                          -theControlEvent.getController().getArrayValue(0))-1;
    if (handleMax <handleMin) 
         { handleMax = handleMin; }
    //if (dateMax>=300) println("11");
    //if (dateMin>=300) println("1");
    
    println("range update, done.");
    println(String.valueOf(handleMin));
    println(String.valueOf(handleMax));
  }
  if ( theControlEvent.isGroup() && theControlEvent.name().equals("Type") ){
      item  = (int) theControlEvent.group().value();
      if (item == 2) {
          a.setDatas(wdatas);
          a.setTags(wtags);
          a.changeSeekBarRange(0,wpmarks);
      }else if (item == 3){
          a.setDatas(mdatas);
          a.setTags(mtags);
          a.changeSeekBarRange(0,mpmarks);
      }else{
          a.setDatas(datas);
          a.setTags(tags);
          a.changeSeekBarRange(0,pmarks);
      } 
  }
 }
