// Benzi desenate: deschide din meniul Citire, citește episodul 1 (web sau „nativ” simulat), verifică filmul.
const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const ph=process.argv[3]==='ph'; const nat=process.argv[4]==='nat';
const p=await b.newPage({viewport:ph?{width:390,height:844}:{width:1180,height:820}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.addInitScript(nat=>{ window.__said=[]; window.__calls=[];
  if(nat){ const H={}; window.native={ call:(m,a)=>{ window.__calls.push(m+(a&&a.key?':'+a.key:'')); if(m==='speak'){ window.__said.push(a.text); return new Promise(r=>setTimeout(()=>r(true),40)); }
      if(m==='asr.perm') return Promise.resolve({speech:'authorized',mic:'granted'}); if(m==='asr.start'){ setTimeout(()=>{ const t=[...document.querySelectorAll('.cm-bub .cm-w')].map(x=>x.textContent).join(' '); (H['asr.partial']||[]).forEach(f=>f({text:t,final:false})); },500); return Promise.resolve(true); } if(m==='asr.saveLast') return Promise.resolve(true); if(m==='rec.start') return Promise.resolve(true); if(m==='rec.play') return new Promise(r=>setTimeout(()=>r(true),120)); if(m==='iap.status') return Promise.resolve(true); if(m==='rec.list'||m==='store.get') return Promise.resolve(m==='rec.list'?[]:''); return Promise.resolve(true); },
    on:(e,f)=>{ (H[e]=H[e]||[]).push(f); }, off:()=>{} }; }
  else window.__nativeSay=t=>{ window.__said.push(t); return new Promise(r=>setTimeout(()=>r(true),40)); }; },nat);
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(900);
const L=process.argv[2]||'ro';
await p.evaluate(L=>{ started=true; window.__switchLang(L); window.openReading(); },L); await p.waitForTimeout(300);
console.log('card:',await p.evaluate(()=>{ const c=document.getElementById('rd-g-comic'); return c?c.textContent:'LIPSĂ'; }));
await p.evaluate(()=>document.getElementById('rd-g-comic').click()); await p.waitForTimeout(400);
await p.screenshot({path:process.env.SC+'/c-lib'+(ph?'p':'')+'.png'});
console.log('lib:',await p.evaluate(()=>[...document.querySelectorAll('.cm-ep .t')].map(x=>x.textContent).join(' | ')));
const EP=+(process.env.EP||0); if(EP){ await p.evaluate(()=>{ localStorage.setItem('cm_prog','{"1":1}'); window.openComics(); }); await p.waitForTimeout(300); } await p.evaluate(EP=>document.querySelectorAll('.cm-ep')[EP].click(),EP);
for(let i=0;i<6;i++){ await p.waitForFunction(()=>document.querySelector('.cm-bub.turn'),null,{timeout:20000}); if(i===0) await p.screenshot({path:process.env.SC+'/c-turn'+(ph?'p':'')+'.png'});
  if(i===1) await p.screenshot({path:process.env.SC+'/c-p2'+(ph?'p':'')+'.png'});
  const bub=await p.evaluate(()=>document.querySelector('.cm-bub').textContent+' | '+document.querySelector('.cm-turn').textContent);
  if(!nat){ await p.waitForFunction(()=>document.querySelector('.cm-ctrl .go'),null,{timeout:20000}); await p.evaluate(()=>document.querySelector('.cm-ctrl .go').click()); }
  await p.waitForFunction(()=>{ const g=document.querySelector('.cm-ctrl .go'); return g&&(g.textContent==='▶'||g.textContent==='🎬'); },null,{timeout:20000});
  if(i===2||(process.env.EP&&i===1)) await p.screenshot({path:process.env.SC+'/c-ok'+(ph?'p':'')+'.png'});
  console.log(i+1,bub); await p.evaluate(()=>document.querySelector('.cm-ctrl .go').click()); await p.waitForTimeout(150); }
await p.waitForFunction(()=>document.querySelector('#cm-main .cm-ctrl .go')&&!document.querySelector('#cm-main.cm-film'),null,{timeout:60000});
console.log('film done; prog',await p.evaluate(()=>localStorage.getItem('cm_prog')),'stars',await p.evaluate(()=>stars));
if(nat) console.log('rec calls:',await p.evaluate(()=>window.__calls.filter(c=>/^rec/.test(c)).length),await p.evaluate(()=>window.__calls.filter(c=>/rec\.play|asr/.test(c)).slice(-6).join(' ')));
console.log('said:',await p.evaluate(()=>window.__said.slice(0,8).join(' | ')));
await p.evaluate(()=>document.querySelector('#cm-main .cm-ctrl .sm').click()); await p.waitForTimeout(300);
console.log('lib after:',await p.evaluate(()=>[...document.querySelectorAll('.cm-ep')].map(x=>x.className+':'+x.querySelector('.st').textContent).join(' | ')));
console.log('ERR',errs.join(' / ')); await b.close(); })();
