// Data de naștere eliminată: cheia veche dispare, meniul Părinți nu are secțiunea, Calendarul nu are 🎂.
const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(700);
await p.evaluate(()=>{ localStorage.setItem('tm_bday',new Date().toISOString().slice(5,10)); localStorage.setItem('keep_me','1'); });
await p.reload(); await p.waitForTimeout(900);
console.log('după reîncărcare: tm_bday =',await p.evaluate(()=>localStorage.getItem('tm_bday')),'| altă setare păstrată =',await p.evaluate(()=>localStorage.getItem('keep_me')));
await p.evaluate(()=>{ window.native=window.native||{}; }); await p.evaluate(()=>window.__hmOpen('par')); await p.waitForTimeout(800);
console.log('meniu Părinți:',await p.evaluate(()=>{ const pn=document.querySelector('.pa-panel'); if(!pn) return 'nu s-a deschis'; return {sectiuni:[...pn.querySelectorAll('summary')].map(s=>s.textContent),cardCumparare:!!pn.querySelector('.pa-purchase'),aniversare:!!pn.querySelector('.pa-personal,.pa-birthday'),credite:!!pn.querySelector('.pa-info')}; }));
await p.screenshot({path:__dirname+'/../../../par.png'});
await p.evaluate(()=>document.querySelector('.pa-close')&&document.querySelector('.pa-close').click());
await p.evaluate(()=>localStorage.setItem('tm_bday','01-01')); // chiar dacă ar apărea din nou, Calendarul nu o mai afișează
await p.evaluate(()=>window.openTime()); await p.waitForTimeout(300);
const cal=await p.evaluate(()=>{ const out=[]; const ws=[...document.querySelectorAll('.tm-world')]; return ws.length; });
for(let w=0;w<await p.evaluate(()=>document.querySelectorAll('.tm-world').length);w++){ await p.evaluate(()=>window.openTime()); await p.waitForTimeout(150); await p.evaluate(w=>document.querySelectorAll('.tm-world')[w].click(),w); await p.waitForTimeout(150);
  const n=await p.evaluate(()=>document.querySelectorAll('#tm-main .rb-card').length);
  for(let i=0;i<n;i++){ await p.evaluate(()=>window.openTime()); await p.waitForTimeout(80); await p.evaluate(w=>document.querySelectorAll('.tm-world')[w].click(),w); await p.waitForTimeout(80); await p.evaluate(i=>document.querySelectorAll('#tm-main .rb-card')[i].click(),i); await p.waitForTimeout(200);
    await p.evaluate(()=>{ const c=document.querySelector('#tm-main .rb-card'); if(c) c.click(); }); await p.waitForTimeout(500);
    const t=await p.evaluate(()=>{ const r=document.querySelector('#tm-main'); return (r.innerText.match(/🎂[^\n]{0,40}/g)||[]).concat([...r.querySelectorAll('svg text')].filter(x=>x.textContent.includes('🎂')).map(()=>'🎂 în svg')).join(' | '); }); if(t) console.log('  🎂 găsit în',w,i,t); } }
console.log('Calendar verificat; erori JS:',errs.length?errs.join(' / '):'niciuna'); await b.close(); })();
