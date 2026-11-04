#!/usr/bin/env python3
"""Capture the real, running simulator app; never renders replacement screens."""
import argparse, json, os, pathlib, signal, subprocess, time, uuid
ROOT = pathlib.Path(__file__).resolve().parents[1]
OUTPUT = pathlib.Path(os.getenv('PUFI_MEDIA_OUTPUT', str(ROOT / 'AppStoreMedia' / '2026-11-04')))
DEVICES = {'iphone': os.getenv('PUFI_IPHONE_UDID', '1B2D97D2-6913-496A-8F5E-6B239431D19B'), 'ipad': os.getenv('PUFI_IPAD_UDID', '3A8C2971-D302-4CB8-AF25-7E9C7AFE1F0F')}
LANGUAGES = ['ro','de','en','fr','it','es','pt','nl','pl','hu','uk','ru']
class Session:
 def __init__(self,family):
  self.family=family; self.udid=DEVICES[family]
  container=subprocess.check_output(['xcrun','simctl','get_app_container',self.udid,'com.horace.pufistars','data'],text=True).strip()
  self.folder=pathlib.Path(container)/'Documents'/'AppStoreCapture'
 def command(self,js=None,action=None,timeout=30):
  key=uuid.uuid4().hex
  request={'id':key,'js':js or 'null','action':action or 'js'}
  temp=self.folder/'command.tmp';temp.write_text(json.dumps(request));temp.replace(self.folder/'command.json')
  if action=='stop': return 'stopping'
  deadline=time.monotonic()+timeout
  while time.monotonic()<deadline:
   try:
    response=json.loads((self.folder/'response.json').read_text())
    if response['id']==key:
     if 'error' in response: raise RuntimeError(response['error'])
     return response.get('value')
   except (FileNotFoundError,json.JSONDecodeError): pass
   time.sleep(.05)
  raise TimeoutError(f'{self.family}: {request}')
 def click(self,selector):
  return self.command(f"(()=>{{const e=document.querySelector({json.dumps(selector)});if(!e)throw Error('Missing '+{json.dumps(selector)});e.click();return true}})()")
 def screenshot(self,path):
  path=pathlib.Path(path);path.parent.mkdir(parents=True,exist_ok=True)
  subprocess.run(['xcrun','simctl','io',self.udid,'screenshot','--mask=ignored',str(path)],check=True,capture_output=True)
 def info(self):
  return self.command("JSON.stringify({lang:lang,title:document.title,width:innerWidth,height:innerHeight,text:document.body.innerText.slice(-1200)})")

SCENES = {
 '01-letter-fishing': "window.__hmOpen('read');document.getElementById('rd-g-fish').click();true",
 '02-coloured-syllables': "window.__hmOpen('read');document.getElementById('rd-g-story').click();document.getElementById('rd-s0').click();true",
 '03-robot-programming': "window.__hmOpen('robo');document.querySelector('[data-lk=\"rb:prog\"]').click();document.querySelector('#rb-main .rb-card').click();true",
 '04-mathematics': "window.__hmOpen('math');document.querySelector('[data-lk=\"mw:add\"]').click();document.querySelector('#mw-main .rb-card').click();true",
 '05-explore-the-clock': "window.__hmOpen('time');document.querySelector('.tm-world').click();document.querySelector('[data-lk=\"tm:explore\"]').click();true",
 '06-pufis-island': "window.openIsland();true",
 '07-shapes': "window.__hmOpen('shapes');document.querySelector('[data-lk=\"gm:tan\"]').click();true",
 '08-chess': "window.openChessGame();document.querySelector('.cg-opp[data-k=\"easy\"]').click();true",
}
CATCH = "(()=>{const flag=document.querySelector('#rd-flag');if(!flag)return false;const letter=flag.childNodes[0].textContent.trim();const fish=[...document.querySelectorAll('.rd-water .rd-fish2')].find(f=>f.querySelector('.b').textContent.trim()===letter);if(fish)fish.click();return !!fish})()"

def reset(s,lang=None):
 if lang:s.command(f"window.__switchLang('{lang}');true")
 s.command('location.reload();true')
 for _ in range(100):
  time.sleep(.1)
  try:
   if s.command("document.readyState==='complete' && !!window.openIsland && !!window.__hmOpen"):break
  except RuntimeError:pass
 time.sleep(.35)

def scene(s,name):
 reset(s);s.command(SCENES[name]);time.sleep(.6)

def prepare_language(s,lang):
 reset(s,lang)
 # Reveal the real alphabet cards. Each first visit earns a star in the game.
 s.command("window.__hmOpen('read');document.getElementById('rd-g-alpha').click();true")
 n=s.command("document.querySelectorAll('.rd-tile').length")
 for i in range(n):
  s.click('#rd-al'+str(i));time.sleep(.045)
 time.sleep(1.3)
 reset(s)

def record(s,lang,name,events):
 raw=OUTPUT/'originals'/lang/s.family/(name+'.mov');raw.parent.mkdir(parents=True,exist_ok=True)
 target=OUTPUT/'upload'/lang/s.family/'previews'/(name+'.mp4');target.parent.mkdir(parents=True,exist_ok=True)
 if target.exists():return False
 log=raw.with_suffix('.log')
 with log.open('w') as err:
  proc=subprocess.Popen(['xcrun','simctl','io',s.udid,'recordVideo','--codec=hevc','--mask=ignored','--force',str(raw)],stdout=subprocess.DEVNULL,stderr=err)
  try:
   deadline=time.monotonic()+15
   while 'Recording started' not in log.read_text():
    if proc.poll() is not None or time.monotonic()>deadline:raise RuntimeError(log.read_text())
    time.sleep(.05)
   start=time.monotonic()
   for sec,action in events:
    time.sleep(max(0,start+sec-time.monotonic()))
    action()
   time.sleep(max(0,start+31.2-time.monotonic()))
  finally:
   proc.send_signal(signal.SIGINT);proc.wait(timeout=20)
 width,height=(886,1920) if s.family=='iphone' else (1600,1200)
 export=['/opt/homebrew/bin/ffmpeg','-hide_banner','-loglevel','error','-y','-ss','0.4','-i',str(raw),'-f','lavfi','-i','anullsrc=channel_layout=stereo:sample_rate=48000','-t','30','-frames:v','900','-vf',f'scale={width}:{height}:flags=lanczos,setsar=1,fps=30,setpts=N/(30*TB)','-c:v','h264_videotoolbox','-profile:v','high','-level:v','4.0','-b:v','10M','-maxrate','12M','-bufsize','20M','-pix_fmt','yuv420p','-c:a','aac','-b:a','256k','-ar','48000','-ac','2','-movflags','+faststart',str(target)]
 subprocess.run(export,check=True)
 print(s.family,lang,name,'30s exported',flush=True)
 return True


def capture_language(s,lang):
 print(s.family,lang,'starting',flush=True)
 prepare_language(s,lang)
 screenshots=OUTPUT/'upload'/lang/s.family/'screenshots'
 for name in SCENES:
  p=screenshots/(name+'.png')
  if p.exists():continue
  scene(s,name)
  if name=='03-robot-programming':
   for _ in range(2):s.click('#rb-main .rb-pal button:nth-child(3)')
  if name=='08-chess':
   s.click('#cg-sq52');s.click('#cg-sq36');time.sleep(1)
  s.screenshot(p)
  print(s.family,lang,name,'PNG',flush=True)
 # Reading: catch letters, then care for the fish in the actual aquarium.
 scene(s,'01-letter-fishing')
 captured_reading=record(s,lang,'01-reading-and-aquarium',[
  (2,lambda:s.command(CATCH)),(9,lambda:s.command(CATCH)),
  (16,lambda:s.click('#rd-aquaBtn')),
  (20,lambda:s.command("(()=>{const b=[...document.querySelectorAll('.aq-food')].find(x=>!x.disabled);if(b)b.click();return true})()")),
  (24,lambda:s.click('#aq-night')),(27,lambda:s.click('#aq-night'))])
 if not captured_reading:
  s.click('#rd-aquaBtn');time.sleep(.5)
 s.screenshot(screenshots/'09-aquarium.png')
 # Programming: solve two real levels and start planning the next route.
 scene(s,'03-robot-programming')
 def arrow(n):return lambda:s.click(f'#rb-main .rb-pal button:nth-child({n})')
 def next_level():
  return s.command("(()=>{const e=document.querySelector('#rb-ovNext');if(e&&!e.hidden)e.click();return true})()")
 captured_robot=record(s,lang,'02-robot-programming',[
  (2,arrow(3)),(3,arrow(3)),(4,arrow(3)),(5,lambda:s.click('#rb-main .rb-b.go')),
  (12,next_level),(15,arrow(3)),(16,arrow(3)),(17,arrow(3)),(18,arrow(4)),
  (19,lambda:s.click('#rb-main .rb-b.go')),(26,next_level),(28,arrow(4)),(29,arrow(4))])
 if captured_robot:s.screenshot(screenshots/'03-robot-programming.png')
 # Island: real earned progress, actual shop purchase and on-island placement.
 scene(s,'06-pufis-island')
 def buy():
  return s.command("(()=>{const b=[...document.querySelectorAll('#isl-shop .it.can:not(.own)')][0];if(b){b.click();return b.dataset.k}return 'none'})()")
 def place():
  return s.command("(()=>{const svg=document.querySelector('#isl-stage svg');const p=svg.createSVGPoint();p.x=735;p.y=665;const q=p.matrixTransform(svg.getScreenCTM());svg.dispatchEvent(new MouseEvent('click',{bubbles:true,clientX:q.x,clientY:q.y}));return true})()")
 record(s,lang,'03-island-and-rewards',[
  (3,lambda:s.command("(()=>{const e=document.querySelector('#isl-stage .isl-egg');if(e)e.dispatchEvent(new MouseEvent('click',{bubbles:true}));return true})()")),
  (4,lambda:s.command("(()=>{const e=document.querySelector('#isl-stage .isl-egg');if(e)e.dispatchEvent(new MouseEvent('click',{bubbles:true}));return true})()")),
  (5,lambda:s.command("(()=>{const e=document.querySelector('#isl-stage .isl-egg');if(e)e.dispatchEvent(new MouseEvent('click',{bubbles:true}));return true})()")),
  (10,lambda:s.command("document.querySelector('#isl-stage svg').dispatchEvent(new MouseEvent('click',{bubbles:true}));true")),
  (12,lambda:s.click('#isl-shopb')),(17,buy),(21,place),
  (25,lambda:s.command("document.querySelector('#isl-stage svg').dispatchEvent(new MouseEvent('click',{bubbles:true}));true"))])
 s.screenshot(screenshots/'06-pufis-island.png')
 print(s.family,lang,'COMPLETE',flush=True)

def run_all(family,languages=LANGUAGES):
 s=Session(family)
 for lang in languages:capture_language(s,lang)

if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('family',choices=DEVICES);parser.add_argument('--js');parser.add_argument('--action');parser.add_argument('--screenshot');parser.add_argument('--all',action='store_true');parser.add_argument('--languages',nargs='+',default=LANGUAGES)
 args=parser.parse_args()
 if args.all:
  run_all(args.family,args.languages);raise SystemExit
 s=Session(args.family)
 if args.js or args.action: print(s.command(args.js,args.action))
 if args.screenshot:s.screenshot(args.screenshot)
 if not(args.js or args.action or args.screenshot): print(s.info())
