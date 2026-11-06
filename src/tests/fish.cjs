const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(800);
await p.evaluate(()=>{ started=true; window.openReading(); }); await p.waitForTimeout(300);
await p.evaluate(()=>document.querySelector('[data-lk="rd:fish"]').click()); await p.waitForTimeout(800);
const log=[];
for(let r=0;r<6;r++){ const info=await p.evaluate(()=>{ if(document.querySelector('.aq-ov')) return 'AQ'; const fl=document.getElementById('rd-flag'); const L=fl.firstChild.textContent.trim().toLowerCase(); const fs=[...document.querySelectorAll('.rd-fish2')]; const t=fs.find(f=>f.querySelector('.b').textContent.trim().toLowerCase()===L)||fs[0]; const k=t.querySelector('.f').dataset.k; t.click(); return k; });
  log.push(info); await p.waitForTimeout(3200); if(await p.evaluate(()=>!!document.querySelector('.aq-ov'))){ log.push('[acvariu deschis]'); await p.screenshot({path:'../fish-aq.png'}); await p.evaluate(()=>document.getElementById('aq-close').click()); await p.waitForTimeout(800); } }
await p.screenshot({path:'../fish-after.png'}); console.log(log.join(' '), await p.evaluate(()=>document.getElementById('rd-aquaBtn').textContent), errs); await b.close(); })();
