// Forme v2: deschide toate nivelurile în toate limbile și joacă automat jocurile noi.
const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const vp=process.argv[3]==='ph'?{width:390,height:844}:{width:1180,height:820}; const p=await b.newPage({viewport:vp}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
const bub=()=>p.evaluate(()=>[...document.querySelectorAll('#gm-main .rb-bubble')].map(x=>x.textContent).join('|'));
const won=()=>p.evaluate(()=>!document.getElementById('gm-ov').hidden);
const open=async(L,gi,li)=>{ await p.evaluate(l=>window.__switchLang(l),L); await p.evaluate(()=>{ document.getElementById('gm-ov').hidden=true; window.openShapes(); }); await p.waitForTimeout(150);
  await p.evaluate(gi=>document.querySelectorAll('#gm-main .gm-cards .rb-card')[gi].click(),gi); await p.waitForTimeout(150);
  await p.evaluate(()=>{ if(document.querySelector('#gm-main .rb-grid .lock')) [...document.querySelectorAll('#gm-main .rb-b')].pop().click(); }); await p.waitForTimeout(120);
  await p.evaluate(li=>document.querySelectorAll('#gm-main .rb-grid .rb-card')[li].click(),li); await p.waitForTimeout(500); };
const S=(x,y)=>p.evaluate(([x,y])=>{ const s=document.querySelector('#gm-main .gm-stage svg'); const pt=s.createSVGPoint(); pt.x=x; pt.y=y; const q=pt.matrixTransform(s.getScreenCTM()); return [q.x,q.y]; },[x,y]);
const N=[6,5,8,7,8,6,5];
// 1) toate nivelurile, toate limbile
for(const L of (process.argv[2]||'ro').split(',')){ const bad=[]; for(let gi=0;gi<7;gi++) for(let li=0;li<N[gi];li++){ await open(L,gi,li); const t=await bub(); if(!t||/undefined|NaN|\[object/.test(t)) bad.push(gi+'/'+li+':'+t); }
  const menu=await p.evaluate(()=>{ window.openShapes(); return document.querySelector('#gm-main').innerText; }); console.log(L,bad.length?bad.join(' ; '):'ok',/undefined/.test(menu)?'MENU BAD':'',errs.splice(0).join(' / ')); }
if(!process.argv[4]){ await b.close(); return; }
// 2) vânătoarea de forme, nivelul 3
await open('ro',0,2); for(let r=0;r<3;r++){ const col=await p.evaluate(()=>document.querySelector('#gm-main .rb-bubble svg g').getAttribute('fill'));
  const idx=await p.evaluate(c=>[...document.querySelectorAll('#gm-main .gm-it')].map((g,i)=>g.querySelector('.gm-ol').getAttribute('stroke')===c?i:-1).filter(i=>i>=0),col);
  if(r===0){ await p.evaluate(c=>{ const g=[...document.querySelectorAll('#gm-main .gm-it')].find(g=>g.querySelector('.gm-ol').getAttribute('stroke')!==c); g.dispatchEvent(new MouseEvent('click',{bubbles:true})); },col); await p.waitForTimeout(300); await p.screenshot({path:__dirname+'/../../../gm-hunt.png'}); }
  for(const i of idx){ await p.evaluate(i=>document.querySelectorAll('#gm-main .gm-it')[i].dispatchEvent(new MouseEvent('click',{bubbles:true})),i); await p.waitForTimeout(120); } await p.waitForTimeout(2600); }
console.log('hunt',await won(),await bub());
// 3) oglinda, nivelul 4 (8x8, 2 culori) și 5 (orizontal)
for(const li of [3,4]){ await open('ro',3,li); for(let r=0;r<3;r++){ await p.evaluate(()=>{ const cells=[...document.querySelectorAll('#gm-main .gm-stage rect[data-r]')]; const n=Math.round(Math.sqrt(cells.length)); const get=(r,c)=>cells.find(e=>+e.dataset.r===r&&+e.dataset.c===c);
    const hor=!!document.querySelector('#gm-main .gm-stage line[x1][y1]') && [...document.querySelectorAll('#gm-main .gm-stage line')].some(l=>l.getAttribute('y1')===l.getAttribute('y2'));
    window.__todo=[]; cells.filter(e=>e.classList.contains('gm-cell')).forEach(e=>{ const r=+e.dataset.r,c=+e.dataset.c; const m=hor?get(n-1-r,c):get(r,n-1-c); const f=m.getAttribute('fill'); if(!['#F2F0F7','#FFFFFF'].includes(f)) window.__todo.push([r,c,f]); }); });
    const todo=await p.evaluate(()=>window.__todo); for(const [r,c,f] of todo){ await p.evaluate(f=>{ const b=[...document.querySelectorAll('#gm-main .rb-ctrl .gm-num')].find(x=>x.style.background&&getComputedStyle(x).backgroundColor===(t=>{ const d=document.createElement('div'); d.style.color=t; document.body.appendChild(d); const v=getComputedStyle(d).color; d.remove(); return v; })(f)); if(b) b.click(); },f); await p.evaluate(([r,c])=>document.querySelector(`#gm-main .gm-cell[data-r="${r}"][data-c="${c}"]`).dispatchEvent(new MouseEvent('click',{bubbles:true})),[r,c]); }
    if(r===0&&li===3) await p.screenshot({path:__dirname+'/../../../gm-mir.png'}); await p.waitForTimeout(2200); } console.log('mirror',li,await won(),await bub()); }
// 4) omida: nivelul 8 (lipsă la mijloc) — încercăm opțiunile până merge
await open('ro',4,7); for(let r=0;r<5;r++){ for(let k=0;k<12;k++){ const done=await p.evaluate(()=>![...document.querySelectorAll('#gm-main .gm-stage text')].some(t=>t.textContent==='?')); if(done) break; const n=await p.evaluate(()=>document.querySelectorAll('#gm-main .rb-ctrl .gm-num').length); await p.evaluate(k=>document.querySelectorAll('#gm-main .rb-ctrl .gm-num')[k].click(),k%n); await p.waitForTimeout(250); }
  if(r===0) await p.screenshot({path:__dirname+'/../../../gm-pat.png'}); await p.waitForTimeout(2200); } console.log('pat',await won(),await bub());
// 5) tabla: nivelul 4 (pentagon, hexagon, 6 pătrățele)
await open('ro',1,3); const SOL=[[[2,1],[4,1],[5,3],[3,5],[1,3]],[[2,1],[4,1],[5,3],[4,5],[2,5],[1,3]],[[1,1],[4,1],[4,3],[1,3]]];
for(const sol of SOL){ for(const [i,j] of [...sol,sol[0]]){ const q=await S(50+i*70,50+j*70); await p.mouse.click(q[0],q[1]); await p.waitForTimeout(80); } await p.waitForTimeout(2400); } console.log('geo4',await won(),await bub());
// 6) puzzle: săgeata și copăcelul (cu ajutorul: rotește piesa și arată locul)
for(const li of [1,3]){ await open('ro',2,li); for(let k=0;k<5;k++){ if(await won()) break; await p.evaluate(()=>[...document.querySelectorAll('#gm-main .rb-ctrl .rb-b')].pop().click()); await p.waitForTimeout(200);
   const mv=await p.evaluate(()=>{ const s=document.querySelector('#gm-main .gm-stage svg'); const slot=s.querySelector('polygon.gm-blink:not(.gm-pc)'), pc=s.querySelector('.gm-pc.gm-blink'); if(!slot||!pc) return null; const c=e=>{ const b=e.getBBox(); return [b.x+b.width/2,b.y+b.height/2]; }; return [c(pc),c(slot)]; }); if(!mv) break;
   const a=await S(...mv[0]); const bb=await S(...mv[1]); await p.mouse.move(a[0],a[1]); await p.mouse.down(); await p.mouse.move(bb[0],bb[1],{steps:8}); await p.mouse.up(); await p.waitForTimeout(400); }
  await p.waitForTimeout(2200); console.log('tan',li,await won(),await bub()); }
console.log('ERR',errs.join(' / ')); await b.close(); })();
