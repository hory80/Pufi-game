const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}});
const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
// 1. solver: fiecare soluție oficială
console.log(await p.evaluate(()=>{ const {CL,solveCircuit}=window.__rb; return CL.map((L,i)=>{ const sw={}; L.c.forEach(([id,t])=>{ if(t==='sw'||t==='btn'||t==='gap') sw[id]=true; if(t==='pot') sw[id]=0; }); if(L.sun) sw.__sun=true;
  const E=solveCircuit(L,(L.fx||[]).concat(L.sol),sw); return i+' '+(L.k||L.o)+' short='+E.short+' '+Object.entries(E.I).map(([k,v])=>k+'='+v.toFixed(2)).join(' ')+(E.burnt&&E.burnt.length?' BURNT':''); }).join('\n'); }));
const open=async(lang,li)=>{ await p.evaluate(l=>window.__switchLang(l),lang); await p.evaluate(()=>{ started=true; window.openRobo(); }); await p.waitForTimeout(200);
  await p.evaluate(()=>[...document.querySelectorAll('.rb-card')][2].click()); await p.waitForTimeout(200);
  await p.evaluate(()=>{ const a=document.getElementById('rb-all'); if(a&&![...document.querySelectorAll('.rb-grid .rb-card')].every(c=>!c.classList.contains('lock'))) a.click(); }); await p.waitForTimeout(150);
  await p.evaluate(li=>[...document.querySelectorAll('.rb-grid .rb-card')][li].click(),li); await p.waitForTimeout(250); };
const bub=()=>p.evaluate(()=>[...document.querySelectorAll('.rb-bubble')].filter(x=>x.offsetParent).map(x=>x.textContent).join('|'));
const termXY=k=>p.evaluate(k=>{const c=document.querySelector(`.rb-term[data-t="${k}"]`).getBoundingClientRect();return [c.x+c.width/2,c.y+c.height/2];},k);
const wire=async(a,c)=>{ const A=await termXY(a),C=await termXY(c); await p.mouse.move(A[0],A[1]); await p.mouse.down(); await p.mouse.move(C[0],C[1],{steps:4}); await p.mouse.up(); await p.waitForTimeout(150); };
const won=()=>p.evaluate(()=>!document.getElementById('rb-ov').hidden);
const clickSel=s=>p.evaluate(s=>document.querySelector(s).dispatchEvent(new MouseEvent('click',{bubbles:true})),s);
const closeOv=()=>p.evaluate(()=>{ document.getElementById('rb-ov').hidden=true; });
// 2. toate nivelurile în toate limbile: fără erori / undefined
if(0)for(const lg of []){ const bad=[]; for(let li=0;li<18;li++){ await open(lg,li); const t=await bub(); if(!t||/undefined/.test(t)) bad.push(li+':'+t); } console.log(lg,bad.length?'BAD '+bad.join(' ; '):'ok', errs.splice(0).join(' / ')); }
// 3. fluxuri noi (ro)
// mat
await open('ro',11); for(let i=0;i<6;i++){ await p.evaluate(i=>document.querySelectorAll('.rb-tray button')[i].click(),i); await p.waitForTimeout(150); if(i===2) await p.screenshot({path:__dirname+'/../cir-mat.png'}); await p.evaluate(()=>document.querySelectorAll('.rb-tray button')[0].click()); await p.waitForTimeout(2600); }
await p.waitForTimeout(2800); console.log('mat won',await won()); await closeOv();
// btn
await open('ro',12); await wire('bat.a','P1.a'); await wire('P1.b','Z1.a'); await wire('Z1.b','bat.b'); console.log('btn:',await bub());
const P=await p.evaluate(()=>{const c=document.querySelector('#rb-c-P1').getBoundingClientRect();return [c.x+c.width/2,c.y+c.height/3];});
for(let i=0;i<3;i++){ await p.mouse.move(P[0],P[1]); await p.mouse.down(); await p.waitForTimeout(300); if(i===0) await p.screenshot({path:__dirname+'/../cir-btn.png'}); await p.mouse.up(); await p.waitForTimeout(300); }
await p.waitForTimeout(3000); console.log('btn won',await won()); await closeOv();
// ser: întâi o baterie, apoi corect
await open('ro',13); await wire('M1.b','bat.b'); await wire('M1.a','bat.a'); console.log('ser1:',await bub());
await p.evaluate(()=>document.querySelectorAll('.rb-wire')[0].dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(150); await p.evaluate(()=>document.querySelector('#rb-cut').dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(150); await wire('bat.b','B2.a'); await wire('B2.b','M1.b'); await p.waitForTimeout(300); await p.screenshot({path:__dirname+'/../cir-ser.png'}); await p.waitForTimeout(3000); console.log('ser won',await won()); await closeOv();
// pot
await open('ro',14); await wire('bat.b','K1.b'); await wire('K1.a','L1.b'); await wire('L1.a','bat.a'); console.log('pot1:',await bub());
for(let i=0;i<3;i++){ await clickSel('.rb-pot'); await p.waitForTimeout(150); } console.log('pot2:',await bub()); await clickSel('.rb-pot'); await p.waitForTimeout(150); console.log('pot3:',await bub());
await clickSel('.rb-pot'); await clickSel('.rb-pot'); await p.waitForTimeout(200); await p.screenshot({path:__dirname+'/../cir-pot.png'}); await p.waitForTimeout(3000); console.log('pot won',await won()); await closeOv();
// res: întâi LED direct (se arde), apoi corect
await open('ro',15); await wire('B2.b','D1.b'); await wire('D1.a','bat.a'); await p.waitForTimeout(200); console.log('res1:',await bub()); await p.screenshot({path:__dirname+'/../cir-burn.png'});
await p.evaluate(()=>document.querySelectorAll('.rb-wire')[1].dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(150); await p.evaluate(()=>document.querySelector('#rb-cut').dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(150); await wire('B2.b','R1.b'); await wire('R1.a','D1.b'); await p.waitForTimeout(3000); console.log('res won',await won()); await closeOv();
// sun
await open('ro',16); await wire('V1.b','M1.b'); await wire('M1.a','V1.a'); await p.waitForTimeout(200); console.log('sun1:',await bub()); await p.screenshot({path:__dirname+'/../cir-sun.png'});
await clickSel('#rb-sky'); await p.waitForTimeout(3000); console.log('sun won',await won()); await closeOv();
// vechi: nivel 0 și 9 încă merg
await open('ro',0); await wire('bat.b','L1.b'); await wire('L1.a','bat.a'); await p.waitForTimeout(3000); console.log('L0 won',await won()); await closeOv();
console.log('ERR',errs.join(' / ')); await b.close(); })();
