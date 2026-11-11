// Where the planner's data lives. The publishable key is meant to be public —
// the database's Row Level Security rules decide who can read/write what.
// NOTE: fill these in with the NEW dedicated Supabase project's values.
window.PLAN_CONFIG = {
  supabaseUrl: 'PENDING_NEW_PROJECT_URL',   // e.g. https://abcd1234.supabase.co
  supabaseKey: 'PENDING_NEW_PUBLISHABLE_KEY',
  importFrom: 'http://localhost:3131/state' // one-time local seed source (http/dev only)
};
