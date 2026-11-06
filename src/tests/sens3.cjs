const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
const sens=['light','line','touch','sonar','thermo','sort'];
const openLv=async(L,si,li)=>{ await p.evaluate(l=>window.__switchLang(l),L); await p.evaluate(()=>{ started=true; window.openRobo(); }); await p.waitForTimeout(80);
  await p.evaluate(()=>[...document.querySelectorAll('.rb-card')][3].click()); await p.waitForTimeout(80);
  await p.evaluate(si=>[...document.querySelectorAll('.rb-card')][si].click(),si); await p.waitForTimeout(80);
  await p.evaluate(()=>{ const a=document.getElementById('rb-all'); if([...document.querySelectorAll('.rb-grid .rb-card')].some(c=>c.classList.contains('lock'))) a.click(); }); await p.waitForTimeout(80);
  await p.evaluate(li=>[...document.querySelectorAll('.rb-grid .rb-card')][li].click(),li); await p.waitForTimeout(250); };
const bub=()=>p.evaluate(()=>[...document.querySelectorAll('.rb-bubble')].filter(x=>x.offsetParent).map(x=>x.textContent).join('|'));
const won=()=>p.evaluate(()=>!document.getElementById('rb-ov').hidden);
const counts=await p.evaluate(()=>{ window.openRobo(); [...document.querySelectorAll('.rb-card')][3].click(); return [...document.querySelectorAll('.rb-card .p')].map(x=>x.textContent); }); console.log('menu',counts.join(' '));
for(const L of (process.argv[2]||'ro,de,en,fr,es,it,pt,nl,pl,uk,ru,hu').split(',')){ const bad=[];
  for(let si=0;si<6;si++){ const n=await p.evaluate(si=>({light:11,line:10,touch:6,sonar:8,thermo:6,sort:5})[['light','line','touch','sonar','thermo','sort'][si]],si);
    for(let li=0;li<n;li++){ await openLv(L,si,li); const t=await bub(); if(!t||/undefined|NaN/.test(t)) bad.push(sens[si]+li+':'+t); } }
  console.log(L,bad.length?bad.join(' ; '):'ok',errs.splice(0).join(' / ')); }
if(process.argv[3]){
 // light lvl 3: stele
 await openLv('ro',0,3); const torch=async(x,y)=>{ const P=await p.evaluate(([x,y])=>{ const s=document.querySelector('.rb-stage svg'); const pt=s.createSVGPoint(); pt.x=x; pt.y=y; const q=pt.matrixTransform(s.getScreenCTM()); return [q.x,q.y]; },[x,y]); await p.mouse.move(P[0],P[1],{steps:6}); };
 const T0=await p.evaluate(()=>{ const r=document.querySelector('#rb-torch').getBoundingClientRect(); return [r.x+r.width/2,r.y+r.height/2]; }); await p.mouse.move(T0[0],T0[1]); await p.mouse.down();
 for(const [x,y] of [[300,180],[150,100],[150,260],[150,420],[400,260],[620,90],[790,260]]){ await torch(x,y); await p.waitForTimeout(3200); }
 await p.mouse.up(); await p.waitForTimeout(2500); console.log('light3 won',await won(),await bub()); await p.screenshot({path:__dirname+'/../s3-light.png'});
 await openLv('ro',0,9); await p.mouse.move(600,400); await p.waitForTimeout(500); await p.screenshot({path:__dirname+'/../s3-dark.png'});
 // line lvl 5 ordine
 await openLv('ro',1,5); const P=async(x,y)=>p.evaluate(([x,y])=>{ const s=document.querySelector('.rb-stage svg'); const pt=s.createSVGPoint(); pt.x=x; pt.y=y; const q=pt.matrixTransform(s.getScreenCTM()); return [q.x,q.y]; },[x,y]);
 let a=await P(110,100); await p.mouse.move(a[0],a[1]); await p.mouse.down(); for(const [x,y] of [[400,100],[700,100],[650,300],[200,420],[450,425],[700,425],[800,420]]){ const q=await P(x,y); await p.mouse.move(q[0],q[1],{steps:12}); } await p.mouse.up();
 await p.screenshot({path:__dirname+'/../s3-line.png'}); await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')].find(b=>b.classList.contains('go')).click()); await p.waitForTimeout(9000); console.log('line5',await won(),await bub());
 // thermo 3 dry
 await openLv('ro',4,3); await p.evaluate(()=>{ for(let i=0;i<3;i++) document.querySelector('.rb-ra').click(); }); await p.evaluate(()=>document.querySelector('.rb-ctrl .rb-b.go').click()); await p.waitForTimeout(4500); await p.screenshot({path:__dirname+'/../s3-dry.png'}); await p.waitForTimeout(6000); console.log('dry',await won(),await bub());
 // sort mix
 await openLv('ro',5,4); const map=await p.evaluate(()=>[...document.querySelectorAll('.rb-ani')].map(g=>g.querySelector('ellipse').getAttribute('fill'))); console.log('mix bowls',map);
 const COL={r:'#FF3B3B',y:'#FFD21E',g:'#3BC48A',b:'#4AA8FF'}; const order=['g','y','r','b']; // ordinea culorilor în panou = SANI0 culori
 for(let ci=0;ci<4;ci++){ const want=map.indexOf(COL[order[ci]]); for(let k=0;k<=want;k++) await p.evaluate(ci=>document.querySelectorAll('.rb-ra')[ci].click(),ci); }
 await p.screenshot({path:__dirname+'/../s3-sort.png'}); await p.evaluate(()=>document.querySelector('.rb-ctrl .rb-b.go').click()); await p.waitForTimeout(16000); console.log('sortmix',await won(),await bub());
 // sonar night
 await openLv('ro',3,4); await p.evaluate(()=>[...document.querySelectorAll('.rb-ctrl .rb-b')][0].click()); await p.waitForTimeout(800); await p.screenshot({path:__dirname+'/../s3-night.png'});
 // touch simon
 await openLv('ro',2,1); await p.waitForTimeout(2500); await p.screenshot({path:__dirname+'/../s3-simon.png'});
 console.log('ERR',errs.join(' / ')); }
await b.close(); })();
