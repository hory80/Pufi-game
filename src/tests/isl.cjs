const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const lang=process.argv[2]||'ro';
for(const [w,h,n] of [[1180,820,'ipad'],[390,844,'ph'],[844,390,'phl']]){ const p=await b.newPage({viewport:{width:w,height:h}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(800); await p.evaluate(l=>window.__switchLang(l),lang);
await p.screenshot({path:'../isl-'+lang+'-'+n+'-home0.png'});
await p.evaluate(()=>{ localStorage.setItem('isl_pts',JSON.stringify({pufi:40,time:14,read:5,math:30,shapes:12,robo:61,chess:3,world:20})); localStorage.removeItem('isl_seen'); window.__islHour=13; });
await p.evaluate(()=>window.openIsland()); await p.waitForTimeout(400); await p.screenshot({path:'../isl-'+lang+'-'+n+'-grow.png'});
await p.waitForTimeout(2500); await p.screenshot({path:'../isl-'+lang+'-'+n+'-day.png'});
await p.evaluate(()=>document.querySelector('#isl-root [data-b=time]').dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(300); await p.screenshot({path:'../isl-'+lang+'-'+n+'-pop.png'});
for(let i=0;i<3;i++){ await p.evaluate(()=>document.querySelector('#isl-root .isl-egg').dispatchEvent(new MouseEvent('click',{bubbles:true}))); await p.waitForTimeout(250); }
await p.waitForTimeout(600); await p.screenshot({path:'../isl-'+lang+'-'+n+'-hatch.png'});
await p.evaluate(()=>{ window.__islHour=22; document.getElementById('isl-back').click(); window.openIsland(); }); await p.waitForTimeout(800); await p.screenshot({path:'../isl-'+lang+'-'+n+'-night.png'});
await p.evaluate(()=>{ window.__islHour=19.5; document.getElementById('isl-back').click(); }); await p.waitForTimeout(500); await p.screenshot({path:'../isl-'+lang+'-'+n+'-home.png'});
console.log(n,errs); await p.close(); }
await b.close(); })();
