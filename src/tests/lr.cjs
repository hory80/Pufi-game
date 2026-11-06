const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1180,height:820}});
const errs=[]; p.on('pageerror',e=>errs.push(e.message)); p.on('console',m=>{ if(m.type()==='warning'||m.type()==='error') errs.push(m.text()); });
await p.goto('file://'+process.argv[2]); await p.waitForTimeout(900);
const sw=async(c)=>{ await p.evaluate(c=>window.__switchLang(c),c); await p.waitForTimeout(500); };
const shot=async n=>p.screenshot({path:'../lr-'+n+'.png'});
const cases=[['openMath',null],['openTime',null],['openReading',null],['openChess',null],['openChessGame',null],['openShapes',null],['openRobo',null],['openSoroban',null],['openPufi','ro']];
for(const [fn,arg] of cases){ await p.evaluate(([fn,arg])=>{ document.querySelectorAll('[id$="root"]').forEach(r=>{}); window[fn](arg); },[fn,arg]); await p.waitForTimeout(500);
  // go one level deeper: click first card/button in visible module
  await p.evaluate(()=>{ const vis=[...document.querySelectorAll('.rb-card,.rd-card,.ch-card,.gm-card,.sa-card')].filter(x=>x.offsetParent); if(vis[0]) vis[0].click(); });
  await p.waitForTimeout(600);
  const mini=await p.evaluate(()=>[...document.querySelectorAll('.lp-mini')].filter(x=>x.offsetParent).length);
  await sw('de'); await shot(fn+'-de'); await sw('fr'); await shot(fn+'-fr'); await sw('ro');
  console.log(fn,'mini visible:',mini);
  await p.evaluate(()=>{ document.querySelectorAll('div[id$="root"]').forEach(r=>{ if(r.id!=='hm-root') r.hidden=true; }); });
}
console.log('ERRORS',errs.slice(0,10)); await b.close(); })();
