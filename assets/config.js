// Where the planner's data lives. The publishable key is meant to be public —
// the database's Row Level Security rules decide who can read/write what.
window.PLAN_CONFIG = {
  supabaseUrl: 'https://xuzazydksvsgocyzkqxr.supabase.co',
  supabaseKey: 'sb_publishable_lu1wi0TZnaFPBwpQxRKkzg_P44DGV6A',
  // one-time import source: the old Mac server, used only to seed the cloud the first time
  importFrom: 'http://localhost:3131/state'
};
