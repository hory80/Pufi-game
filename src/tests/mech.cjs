const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
const N=[8,10,8,7,5,7], names=['lever','gears','bike','ramp','pulley','cata'];
const openLv=async(L,si,li)=>{ await p.evaluate(l=>window.__switchLang(l),L); await p.evaluate(()=>{ started=true; window.openRobo(); }); await p.waitForTimeout(80);
  await p.evaluate(()=>[...document.querySelectorAll('.rb-card')][1].click()); await p.waitForTimeout(80);
  await p.evaluate(si=>[...document.querySelectorAll('.rb-card')][si].click(),si); await p.waitForTimeout(80);
  await p.evaluate(()=>{ const a=document.getElementById('rb-all'); if([...document.querySelectorAll('.rb-grid .rb-card')].some(c=>c.classList.contains('lock'))) a.click(); }); await p.waitForTimeout(80);
  await p.evaluate(li=>[...document.querySelectorAll('.rb-grid .rb-card')][li].click(),li); await p.waitForTimeout(250); };
const bub=()=>p.evaluate(()=>[...document.querySelectorAll('.rb-bubble')].filter(x=>x.offsetParent).map(x=>x.textContent).join('|'));
const won=()=>p.evaluate(()=>!document.getElementById('rb-ov').hidden);
const S=(x,y)=>p.evaluate(([x,y])=>{ const s=document.querySelector('.rb-stage svg'); const pt=s.createSVGPoint(); pt.x=x; pt.y=y; const q=pt.matrixTransform(s.getScreenCTM()); return [q.x,q.y]; },[x,y]);
await p.evaluate(()=>{ window.openRobo(); [...document.querySelectorAll('.rb-card')][1].click(); }); console.log('menu',await p.evaluate(()=>[...document.querySelectorAll('.rb-card')].map(c=>c.querySelector('.t').textContent+' '+c.querySelector('.p').textContent).join(' | ')));
for(const L of (process.argv[2]||'ro').split(',')){ const bad=[]; for(let si=0;si<6;si++) for(let li=0;li<N[si];li++){ await openLv(L,si,li); const t=await bub(); if(!t||/undefined|NaN/.test(t)) bad.push(names[si]+li+':'+t); }
  const menu=await p.evaluate(()=>{ window.openRobo(); [...document.querySelectorAll('.rb-card')][1].click(); return [...document.querySelectorAll('.rb-card .t')].map(x=>x.textContent).join(','); });
  console.log(L,bad.length?bad.join(' ; '):'ok',/undefined/.test(menu)?'MENU BAD '+menu:'',errs.splice(0).join(' / ')); }
if(process.argv[3]){
if(0){
 await openLv('ro',1,8); for(let i=0;i<3;i++) await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')][0].click()); await p.waitForTimeout(6500); console.log('gears8',await won(),await bub());
 await openLv('ro',1,8); for(let i=0;i<2;i++) await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')][1].click()); await p.waitForTimeout(800); console.log('gears8 MM:',await bub());
 // bike count3
 for(const li of [1,5,7]){ await openLv('ro',2,li); await p.waitForTimeout(300); await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')][0].click());
  const info=await p.evaluate(()=>{ const t=[...document.querySelectorAll('#rb-bk text')].map(x=>x.textContent); return t; }); await p.waitForTimeout(8000);
  const back=parseInt(info[1]); const turns=await p.evaluate(()=>(document.querySelector('.rb-ctrl .rb-b')||{}).textContent); const ratio=36/back;
  const opts=await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')].map(b=>b.textContent)); const tr=li===1?1:li===5?2:null;
  console.log('bike',li,info.join('/'),'opts',opts.join(','),'ratio',ratio);
  const ans=opts.find(o=>tr?+o===ratio*tr:(+o===ratio*2||+o===ratio*3)); await p.evaluate(a=>[...document.querySelectorAll('.rb-ctrl .rb-b')].find(b=>b.textContent===a).click(),ans); await p.waitForTimeout(3500); console.log('  won',await won(),await bub()); }
 // ramp ice
 await openLv('ro',3,2); for(let k=0;k<3;k++){ const tx=await p.evaluate(()=>{ const r=document.querySelector('#rb-tgt rect'); return +r.getAttribute('x')+(+r.getAttribute('width'))/2; }); const D=tx-310, h=D/(2.3*1.45)+30; const a=await S(70,380-h); await p.mouse.click(a[0],a[1]); await p.waitForTimeout(100);
   await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')].find(b=>b.classList.contains('go')).click()); await p.waitForTimeout(4200); } console.log('ramp ice',await won(),await bub());
 // pulley 3
 await openLv('ro',4,3); for(const n of [0,2,2]){ await p.evaluate(n=>[...document.querySelectorAll('.rb-ctrl .rb-ctrl .rb-b')][n].click(),n); await p.waitForTimeout(100); const pb=await p.evaluate(()=>{ const r=[...document.querySelectorAll('.rb-ctrl .rb-b')].find(b=>b.classList.contains('go')).getBoundingClientRect(); return [r.x+r.width/2,r.y+r.height/2]; });
   await p.mouse.move(pb[0],pb[1]); await p.mouse.down(); await p.waitForTimeout(n===0?3500:9500); await p.mouse.up(); await p.waitForTimeout(2500); } console.log('pulley3',await won(),await bub());
 await openLv('ro',4,2); { const pb=await p.evaluate(()=>{ const r=[...document.querySelectorAll('.rb-ctrl .rb-b')].find(b=>b.classList.contains('go')).getBoundingClientRect(); return [r.x+r.width/2,r.y+r.height/2]; }); await p.mouse.move(pb[0],pb[1]); await p.mouse.down(); await p.waitForTimeout(800); await p.screenshot({path:__dirname+'/../m-pul.png'}); await p.mouse.up(); console.log('pulley heavy:',await bub()); }
 // catapult 0 & 3: căutare unghi/forță
 for(const li of [0,3]){ await openLv('ro',5,li); const T=li===0?[600,390]:[720,390], W=li===3?[440,230,40,210]:null;
  const best=await p.evaluate(([T,W])=>{ const G=600,V=720,CX=120,CY=380; for(let A=20;A<=75;A+=1) for(let L=30;L<=150;L+=2){ const a=-A*Math.PI/180, v=V*L/150; let x=CX,y=CY,vx=Math.cos(a)*v,vy=Math.sin(a)*v, ok=false; for(let t=0;t<6;t+=1/180){ vy+=G/180; x+=vx/180; y+=vy/180; if(W&&x>W[0]-8&&x<W[0]+W[2]+8&&y>W[1]-8&&y<W[1]+W[3]) break; if(Math.hypot(x-T[0],y-T[1])<40){ ok=true; break; } if(y>430) break; } if(ok) return [a,L]; } return null; },[T,W]);
  const [a,L]=best; const st=await S(120,380), en=await S(120-L*Math.cos(a),380-L*Math.sin(a)); await p.mouse.move(st[0],st[1]); await p.mouse.down(); await p.mouse.move(en[0],en[1],{steps:8}); if(li===3) await p.screenshot({path:__dirname+'/../m-cat.png'}); await p.mouse.up(); await p.waitForTimeout(4500); console.log('cata',li,best.map(x=>x.toFixed(2)),await won(),await bub()); }
}
 await openLv('ro',0,4); for(let k=0;k<3;k++){ await p.evaluate(()=>[...document.querySelectorAll('#rb-main .rb-ctrl .rb-b')].pop().click()); await p.waitForTimeout(300);
   const g=await p.evaluate(()=>{ const t=document.querySelector('#rb-plank .rb-need'); return t?[+t.getAttribute('x'),t.textContent]:null; }); if(!g){ console.log('no ghost'); break; } const d=Math.round((g[0]-450)/90); const ani={'🐭':0,'🐰':1,'🐶':2,'🐘':3};
   const bi=await p.evaluate(e=>[...document.querySelectorAll('.rb-tray button')].findIndex(b=>b.textContent.includes(e)),g[1]); const br=await p.evaluate(i=>{ const r=document.querySelectorAll('.rb-tray button')[i].getBoundingClientRect(); return [r.x+r.width/2,r.y+r.height/2]; },bi);
   const to=await S(450+d*90,290); await p.mouse.move(br[0],br[1]); await p.mouse.down(); await p.mouse.move(to[0],to[1],{steps:6}); await p.mouse.up(); await p.waitForTimeout(1500);
   for(let w=0;w<4;w++){ const has=await p.evaluate(()=>document.querySelectorAll('.rb-tray button').length===4&&!!document.querySelector('.rb-tray button b')); if(!has) break; await p.evaluate(w=>{ const b=document.querySelectorAll('.rb-tray button')[w]; if(b) b.click(); },w); await p.waitForTimeout(1800); if(await won()) break; const q=await bub(); if(!/cântărește cât…/.test(q)) break; } }
 await p.waitForTimeout(1000); console.log('lever4',await won(),await bub());
 console.log('ERR',errs.join(' / ')); }
await b.close(); })();
