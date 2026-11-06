const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const lang=process.argv[2]||'ro';
for(const [w,h,n] of [[1180,820,'ipad'],[390,844,'ph']]){ const p=await b.newPage({viewport:{width:w,height:h}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(800); await p.evaluate(l=>window.__switchLang(l),lang);
await p.evaluate(()=>window.openTime()); await p.waitForTimeout(300);
const go=async(w,k,lv,name,ms)=>{ await p.evaluate(([w,k,lv])=>{ document.querySelectorAll('.tm-world')[w].click(); },[w,k,lv]); await p.waitForTimeout(250);
  await p.evaluate(k=>[...document.querySelectorAll('#tm-main .rb-card')].find(c=>c.dataset.lk==='tm:'+k).click(),k); await p.waitForTimeout(300);
  const cards=await p.evaluate(()=>document.querySelectorAll('#tm-main .rb-card').length); if(cards&&lv!=null) { await p.evaluate(lv=>document.querySelectorAll('#tm-main .rb-card')[lv].click(),lv); }
  await p.waitForTimeout(ms||1500); await p.screenshot({path:'../tmv-'+lang+'-'+n+'-'+name+'.png'}); await p.evaluate(()=>{ window.openTime(); }); await p.waitForTimeout(300); };
await go(0,'explore',null,'explore',900);
await go(0,'balloon',0,'balloon',3500);
await p.evaluate(()=>document.querySelectorAll('.tm-world')[1].click()); await p.waitForTimeout(250);
await p.evaluate(()=>[...document.querySelectorAll('#tm-main .rb-card')].find(c=>c.dataset.lk==='tm:wake').click()); await p.waitForTimeout(300);
await p.evaluate(()=>document.querySelectorAll('#tm-main .rb-card')[0].click()); await p.waitForTimeout(1200); await p.screenshot({path:'../tmv-'+lang+'-'+n+'-wake.png'});
await p.evaluate(()=>{const b=[...document.querySelectorAll('#tm-main button')].find(x=>x.textContent.includes('⏰'));b&&b.click();}); await p.waitForTimeout(1500); await p.screenshot({path:'../tmv-'+lang+'-'+n+'-wake2.png'}); await p.evaluate(()=>window.openTime()); await p.waitForTimeout(300);
await go(0,'cuckoo',0,'cuckoo',2500);
await go(3,'tree',null,'tree',800);
console.log(n,errs); await p.close(); }
await b.close(); })();
