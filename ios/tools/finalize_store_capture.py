#!/usr/bin/env python3
"""Arrange earned decorations through the real UI and complete the localized media set."""
import sys,time,json,concurrent.futures,pathlib
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parent))
from app_store_capture import Session,scene,reset,OUTPUT,LANGUAGES,record
POS=[(380,710),(560,730),(780,745),(990,720),(1190,660),(1250,570),(1180,450),(1020,540),(850,570),(560,565),(460,515),(670,580)]
def place(s,x,y):
 return s.command(f"(()=>{{const svg=document.querySelector('#isl-stage svg');const p=svg.createSVGPoint();p.x={x};p.y={y};const q=p.matrixTransform(svg.getScreenCTM());svg.dispatchEvent(new MouseEvent('click',{{bubbles:true,clientX:q.x,clientY:q.y}}));return true}})()")
def move(s,i):
 s.command(f"document.querySelector('#isl-stage .isl-d[data-i=\"{i}\"]').dispatchEvent(new MouseEvent('click',{{bubbles:true}}));true")
 s.click('#isl-pop [data-a=m]')
def run(family):
 s=Session(family);scene(s,'06-pufis-island')
 decos=json.loads(s.command("localStorage.getItem('isl_deco')"));print(family,len(decos),'real decorations',flush=True)
 for i,d in enumerate(decos):
  move(s,i);place(s,*POS[i%len(POS)])
 for lang in LANGUAGES:
  reset(s,lang);s.command('window.openIsland();true');time.sleep(.5)
  s.screenshot(OUTPUT/'upload'/lang/family/'screenshots'/'06-pufis-island.png')
 for lang in ['ro','de']:
  reset(s,lang);scene(s,'01-letter-fishing');s.click('#rd-aquaBtn');time.sleep(.6)
  s.screenshot(OUTPUT/'upload'/lang/family/'screenshots'/'09-aquarium.png')
  scene(s,'03-robot-programming');s.click('#rb-back');s.click('#rb-main .rb-card:nth-child(3)')
  for n in [4,4,3,3]:s.click(f'#rb-main .rb-pal button:nth-child({n})')
  s.screenshot(OUTPUT/'upload'/lang/family/'screenshots'/'03-robot-programming.png')
 for lang in ['ro','ru']:
  reset(s,lang);scene(s,'06-pufis-island')
  target=OUTPUT/'upload'/lang/family/'previews'/'03-island-and-rewards.mp4'
  target.unlink() # Re-record this local generated export with a visible move action.
  record(s,lang,'03-island-and-rewards',[
   (3,lambda:s.command("document.querySelector('#isl-stage .isl-b[data-b=\"read\"]').dispatchEvent(new MouseEvent('click',{bubbles:true}));true")),
   (8,lambda:s.command("document.querySelector('#isl-stage svg').dispatchEvent(new MouseEvent('click',{bubbles:true}));true")),
   (10,lambda:s.click('#isl-shopb')),(15,lambda:s.click('#isl-shop [data-a=x]')),
   (18,lambda:move(s,1)),(22,lambda:place(s,590,735)),
   (26,lambda:s.command("document.querySelector('#isl-stage svg').dispatchEvent(new MouseEvent('click',{bubbles:true}));true"))])
 print(family,'final captures done',flush=True)
with concurrent.futures.ThreadPoolExecutor(2) as ex:list(ex.map(run,['iphone','ipad']))
