#!/usr/bin/env python3
"""Validate every upload asset against the Apple specs recorded in the guide."""
import argparse, hashlib, json, pathlib, struct, subprocess, time
LANGUAGES=['ro','de','en','fr','it','es','pt','nl','pl','hu','uk','ru']
FAMILIES={'iphone':((1206,2622),(886,1920)),'ipad':((2752,2064),(1600,1200))}
parser=argparse.ArgumentParser();parser.add_argument('folder',type=pathlib.Path);parser.add_argument('--partial',action='store_true');args=parser.parse_args()
root=args.folder.resolve();files=[];errors=[];sets=[]
def read_bytes(path):
 for attempt in range(3):
  try:return path.read_bytes()
  except OSError:
   if attempt==2:raise
   time.sleep(1)
for lang in LANGUAGES:
 for family,(png_size,video_size) in FAMILIES.items():
  base=root/'upload'/lang/family
  pngs=sorted((base/'screenshots').glob('*.png'));videos=sorted((base/'previews').glob('*.mp4'))
  if not args.partial and (len(pngs)!=9 or len(videos)!=3):errors.append(f'{lang}/{family}: {len(pngs)} PNG, {len(videos)} MP4; expected 9 and 3')
  for path in pngs:
   content=read_bytes(path);width,height=struct.unpack('>II',content[16:24]);depth,color=content[24:26]
   if (width,height)!=png_size or depth!=8 or color!=2:errors.append(f'{path}: unexpected PNG format {width}x{height}, depth {depth}, color type {color}')
   files.append({'path':str(path.relative_to(root)),'kind':'screenshot','width':width,'height':height,'bytes':len(content),'sha256':hashlib.sha256(content).hexdigest()})
  for path in videos:
   content=read_bytes(path)
   probe=json.loads(subprocess.run(['/opt/homebrew/bin/ffprobe','-v','error','-show_streams','-show_format','-of','json','-i','pipe:0'],input=content,stdout=subprocess.PIPE,check=True,timeout=30).stdout)
   video=next((s for s in probe['streams'] if s['codec_type']=='video'),{})
   audio=next((s for s in probe['streams'] if s['codec_type']=='audio'),{})
   duration=float(video['duration'])
   if (video.get('width'),video.get('height'))!=video_size:errors.append(f'{path}: incorrect video dimensions')
   if video.get('codec_name')!='h264' or video.get('profile')!='High' or video.get('level')!=40:errors.append(f'{path}: incorrect codec/profile/level')
   if video.get('r_frame_rate')!='30/1' or video.get('avg_frame_rate')!='30/1' or video.get('nb_frames')!='900':errors.append(f'{path}: expected 900 frames at constant 30 fps')
   if video.get('pix_fmt')!='yuv420p' or video.get('field_order')!='progressive' or video.get('sample_aspect_ratio')!='1:1':errors.append(f'{path}: incorrect pixel/field/aspect format')
   if abs(duration-30)>.001:errors.append(f'{path}: duration {duration}, expected 30.000')
   if audio.get('codec_name')!='aac' or audio.get('channels')!=2 or audio.get('sample_rate')!='48000':errors.append(f'{path}: expected stereo AAC 48 kHz')
   if path.stat().st_size>=500_000_000:errors.append(f'{path}: exceeds 500 MB')
   files.append({'path':str(path.relative_to(root)),'kind':'preview','width':video.get('width'),'height':video.get('height'),'duration':duration,'frames':video.get('nb_frames'),'fps':video.get('r_frame_rate'),'audio':'silent AAC stereo 48 kHz','bytes':len(content),'sha256':hashlib.sha256(content).hexdigest()})
  sets.append({'language':lang,'device':family,'screenshots':len(pngs),'previews':len(videos)})
manifest={'capture_date':'2026-11-04','source_commit':'d974308','bundle_identifier':'com.horace.pufistars','runtime':'iOS / iPadOS 26.5','devices':{'iphone':'iPhone 17 Pro','ipad':'iPad Pro 13-inch (M5)'},'sets':sets,'files':files,'errors':errors}
(root/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
png_count=sum(x['kind']=='screenshot' for x in files);mp4_count=sum(x['kind']=='preview' for x in files)
report=['# Verificarea fișierelor App Store', '',f'{png_count} capturi PNG și {mp4_count} clipuri MP4 verificate.','', '| Limbă | Dispozitiv | PNG | MP4 |','|---|---|---:|---:|']
report += [f"| {s['language']} | {s['device']} | {s['screenshots']} | {s['previews']} |" for s in sets]
report += ['', 'Verificări: dimensiuni native PNG, RGB 8-bit fără alpha; rezoluții video Apple; H.264 High Level 4.0, progressive, yuv420p, pixeli pătrați; exact 900 cadre / 30 fps / 30.000 s; AAC stereo 48 kHz; sub 500 MB/clip. SHA-256 pentru fiecare fișier în manifest.json.', '', 'Rezultat: '+('PASS' if not errors else 'FAIL'), '']
report += errors
(root/'VALIDATION.md').write_text('\n'.join(report)+'\n')
print(f'{png_count} PNG; {mp4_count} MP4; {len(errors)} errors')
for error in errors:print(error)
raise SystemExit(bool(errors))
