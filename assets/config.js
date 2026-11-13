// Where the planner's data lives. The publishable key is meant to be public —
// the database's Row Level Security rules decide who can read/write what.
// Dedicated Supabase project "Calendar" (qlqafyxwqjegabeccfpw).
window.PLAN_CONFIG = {
  supabaseUrl: 'https://qlqafyxwqjegabeccfpw.supabase.co',
  supabaseKey: 'sb_publishable_UJxuRtA88jduAqR23nJD2A_iSAXzeQT',
  importFrom: 'http://localhost:3131/state' // one-time local seed source (http/dev only)
};
