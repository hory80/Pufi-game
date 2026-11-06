const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}});
await p.addInitScript(()=>{ window.__said=[]; window.__nativeSay=t=>{ window.__said.push(t); return new Promise(r=>setTimeout(()=>r(true),30)); }; });
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(800);
await p.evaluate(()=>{ started=true; localStorage.setItem('tm_all','1'); window.__switchLang('ro'); window.openTime(); });
const worlds=await p.evaluate(()=>document.querySelectorAll('.tm-world').length);
for(let w=0;w<worlds;w++){ const keys=await p.evaluate(w=>{ window.openTime(); document.querySelectorAll('.tm-world')[w].click(); return [...document.querySelectorAll('#tm-main .rb-card')].map(c=>c.dataset.lk); },w);
  for(const k of keys){ for(let lv=0;lv<6;lv++){ const ok=await p.evaluate(([w,k,lv])=>{ window.openTime(); document.querySelectorAll('.tm-world')[w].click(); const c=[...document.querySelectorAll('#tm-main .rb-card')].find(c=>c.dataset.lk===k); if(!c) return false; c.click(); const L=document.querySelectorAll('#tm-main .rb-card'); if(!L.length) return lv===0; if(lv>=L.length) return false; L[lv].click(); return true; },[w,k,lv]); if(!ok) break; await p.waitForTimeout(1500); } } }
const s=await p.evaluate(()=>window.__said); console.log([...new Set(s)].filter(x=>/\d|ore|oră|ora|minut/.test(x)).join('\n')); await b.close(); })();
