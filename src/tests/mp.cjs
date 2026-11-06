const {chromium}=require('playwright');(async()=>{const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.addInitScript(()=>{ const subs={}; window.native={ call(cmd,a){ const R={'speak':true,'store.get':'','iap.status':true,'asr.start':{ok:false,reason:'speech-denied'},'gate':true,'asr.perm':{speech:'notDetermined',mic:'undetermined'}}; return new Promise(r=>setTimeout(()=>r(cmd in R?R[cmd]:true),5)); }, on(e,f){ (subs[e]=subs[e]||[]).push(f); }, off(){} }; });
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
await p.evaluate(()=>{ started=true; window.openReading(); }); await p.waitForTimeout(300);
await p.evaluate(()=>document.querySelector('[data-lk="rd:story"]').click()); await p.waitForTimeout(300);
await p.evaluate(()=>document.getElementById('rd-s0').click()); await p.waitForTimeout(300);
await p.evaluate(()=>document.getElementById('rd-sm-mic').click()); await p.waitForTimeout(500); await p.screenshot({path:'../mp-ask.png'});
await p.evaluate(()=>document.querySelector('.mp-box .go').click()); await p.waitForTimeout(500); await p.screenshot({path:'../mp-fail.png'});
console.log(errs); await b.close(); })();
