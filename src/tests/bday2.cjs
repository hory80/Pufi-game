// Simulează aplicația iOS (window.native): copia de rezervă conține tm_bday → nu trebuie restaurată și nici salvată din nou.
const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:390,height:844}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.addInitScript(()=>{ window.__saved=[]; const snap=JSON.stringify({tm_bday:'07-14',rd_my:'["x"]',gm_data:'{"prog":{"ghunt0":3}}'});
  window.native={call:(cmd,a)=>{ if(cmd==='store.get') return Promise.resolve(snap); if(cmd==='store.set'){ window.__saved.push(a.snapshot); return Promise.resolve(true); } if(cmd==='gate') return Promise.resolve(true); if(cmd==='iap.price') return Promise.resolve('9,90 CHF'); if(cmd==='iap.status') return Promise.resolve(false); if(cmd==='rec.list') return Promise.resolve([]); if(cmd==='voiceInfo') return Promise.resolve({name:'Ioana'}); return Promise.resolve(null); },on(){},off(){}}; });
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(2500);
console.log('restaurare: tm_bday =',await p.evaluate(()=>localStorage.getItem('tm_bday')),'| gm_data restaurat =',await p.evaluate(()=>localStorage.getItem('gm_data')),'| rd_my =',await p.evaluate(()=>localStorage.getItem('rd_my')));
await p.evaluate(()=>localStorage.setItem('x','1')); await p.waitForTimeout(1800);
console.log('salvări către aplicație:',await p.evaluate(()=>window.__saved.length),'| conțin tm_bday:',await p.evaluate(()=>window.__saved.some(s=>s.includes('tm_bday'))));
await p.evaluate(()=>window.__hmOpen('par')); await p.waitForTimeout(1200);
console.log('meniu:',await p.evaluate(()=>{ const pn=document.querySelector('.pa-panel'); return {ordine:[...pn.querySelector('.pa-body').children].map(e=>e.className.split(' ').find(c=>c.startsWith('pa-'))),sectiuni:pn.querySelectorAll('details').length,pret:(pn.querySelector('.pa-primary')||{}).textContent,laude:(pn.querySelector('.pa-recordings select')||{options:[]}).options.length,aniversare:!!pn.querySelector('.pa-personal,.pa-birthday')}; }));
await p.screenshot({path:'/tmp/claude-0/-home-claude/e510de94-0c6d-5791-98b4-fb6f954e7f2d/scratchpad/par.png'});
console.log('erori JS:',errs.length?errs.join(' / '):'niciuna'); await b.close(); })();
