#!/usr/bin/env python3
"""Contact sheets for QA only. Never place them in the upload folders."""
import concurrent.futures,pathlib,subprocess,sys,time
root=pathlib.Path(sys.argv[1]).resolve()
def movie_sheet(path):
 relative=path.relative_to(root/'upload');target=(root/'review'/'frames'/relative).with_suffix('.jpg');target.parent.mkdir(parents=True,exist_ok=True)
 size='184:400' if 'iphone' in relative.parts else '400:300'
 content=path.read_bytes()
 command=['/opt/homebrew/bin/ffmpeg','-hide_banner','-loglevel','error','-y','-hwaccel','videotoolbox','-i','pipe:0','-vf',f'fps=1/10,scale={size},tile=3x1','-frames:v','1',str(target)]
 subprocess.run(command,input=content,check=True,timeout=60)
 return target
with concurrent.futures.ThreadPoolExecutor(4) as pool:
 for p in pool.map(movie_sheet,sorted((root/'upload').glob('*/*/previews/*.mp4'))):print(p.relative_to(root),flush=True)
