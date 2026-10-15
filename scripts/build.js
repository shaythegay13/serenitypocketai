const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const source = path.join(root, 'hackathon', 'index.html');
const dist = path.join(root, 'dist');

const html = fs.readFileSync(source, 'utf8');
const required = [
  'Responsible Betting Advisor',
  'function analyticalAgent',
  'function harmAgent',
  'function unifiedRecommendationAgent',
  'id="analyzeBtn"'
];

for (const marker of required) {
  if (!html.includes(marker)) {
    console.error(`Build failed: index.html is missing ${marker}`);
    process.exit(1);
  }
}

fs.mkdirSync(dist, { recursive: true });
fs.copyFileSync(source, path.join(dist, 'index.html'));
fs.copyFileSync(path.join(root, 'hackathon', 'vercel.json'), path.join(dist, 'vercel.json'));

console.log('Built dist/index.html');
