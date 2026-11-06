const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(800); await p.evaluate(()=>window.__switchLang('ro'));
const go=async(w,k,lv)=>{ await p.evaluate(()=>window.openTime()); await p.waitForTimeout(250); await p.evaluate(w=>document.querySelectorAll('.tm-world')[w].click(),w); await p.waitForTimeout(200);
  await p.evaluate(k=>[...document.querySelectorAll('#tm-main .rb-card')].find(c=>c.dataset.lk==='tm:'+k).click(),k); await p.waitForTimeout(250);
  await p.evaluate(lv=>{ const a=document.querySelectorAll('#tm-main .rb-card'); if(a[lv]) a[lv].click(); },lv); await p.waitForTimeout(1500); };
const bub=()=>p.evaluate(()=>[...document.querySelectorAll('#tm-main .rb-bubble')].map(x=>x.textContent).join('|'));
// rotește acul orar ÎNAPOI de pe poziția curentă până la ora h (trecând peste 12)
const turnBack=async(id,h)=>{ const g=await p.evaluate(id=>{ const s=document.querySelector('#tm-main svg'); const c=s.querySelector('#'+id+'-face')||s.querySelector('#'+id+' circle'); const r=c.getBoundingClientRect(); return [r.x+r.width/2,r.y+r.height/2,r.width/2]; },id);
  const [cx,cy,R]=g; const ha=await p.evaluate(id=>{ const t=document.querySelector('#'+id+'-h').getAttribute('transform'); return parseFloat(t.slice(7)); },id);
  const pos=a=>[cx+Math.sin(a*Math.PI/180)*R*.4, cy-Math.cos(a*Math.PI/180)*R*.4];
  let a=ha; const target=(h%12)*30; let [x,y]=pos(a); await p.mouse.move(x,y); await p.mouse.down();
  let steps=0; let tgt=target; if(tgt>=a) tgt-=360; // mergem în sens invers, trecând de 12
  while(a>tgt+0.5&&steps<200){ a=Math.max(tgt,a-8); [x,y]=pos(a); await p.mouse.move(x,y); steps++; }
  await p.mouse.up(); await p.waitForTimeout(200); };
const okBtn=()=>p.evaluate(()=>{ const b=document.querySelector('#tm-main .rb-b.go'); if(b) b.click(); });
console.log(await p.evaluate(()=>document.querySelector('#tm-main').innerHTML.slice(0,300)));
let res=[]; await go(0,'station',0); console.log(await p.evaluate(()=>document.querySelector('#tm-main').innerHTML.slice(0,400)));
for(let r=0;r<6;r++){ const dep=await p.evaluate(()=>document.querySelector('#tm-dep').textContent); const h=parseInt(dep); await turnBack('tc',h+12); await okBtn(); await p.waitForTimeout(400); const t=await bub(); res.push(dep+(/altă oră/.test(t)?' ✗':' ✓')); await p.waitForTimeout(2600); }
console.log('station:',res.join(' '));
// cucu, potrivește ceasul
await go(1,'wake',0); res=[];
for(let r=0;r<5;r++){ const t0=await bub(); const RO=['douăsprezece','unu','două','trei','patru','cinci','șase','șapte','opt','nouă','zece','unsprezece','douăsprezece']; let h=RO.findIndex((w,i)=>i>0&&new RegExp('ora '+w+'\\b').test(t0)); if(h<0) h=RO.findIndex((w,i)=>i>0&&t0.includes(' '+w)); await turnBack('tc',h); await okBtn(); await p.waitForTimeout(500); const t=await bub(); res.push(h+':'+(/altă oră/.test(t)?'✗':'✓')); await p.waitForTimeout(3500); }
console.log('wake:',res.join(' '));
// trezirea + dayclk: variație
await go(1,'dayclk',0); const s1=await bub(); await go(1,'dayclk',0); const s2=await bub(); console.log('dayclk1:',s1,'\n dayclk2:',s2);
console.log('ERR',errs.join(' / ')); await b.close(); })();
