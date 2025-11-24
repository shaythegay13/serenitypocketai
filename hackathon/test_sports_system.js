// Test script to verify sports system functionality
// This tests the core logic without requiring a web server

console.log('🧪 Testing Responsible Betting Advisor Sports System...\n');

// Mock the DOM elements and functions we need to test
const mockElement = (value = '') => ({
  value,
  innerHTML: '',
  addEventListener: () => {},
  appendChild: () => {},
  classList: { add: () => {}, remove: () => [] }
});

// Mock document
const document = {
  getElementById: (id) => {
    const elements = {
      'sport': mockElement('ICE_HOCKEY'),
      'currentGame': mockElement(''),
      'betType': mockElement('Moneyline'),
      'odds': mockElement(''),
      'betAmount': mockElement('50'),
      'budget': mockElement('500'),
      'favoriteTeam': mockElement(''),
      'underdogTeam': mockElement(''),
      'favoriteRecord': mockElement(''),
      'underdogRecord': mockElement(''),
      'injuries': mockElement(''),
      'weather': mockElement(''),
      'currentEmotion': mockElement('Neutral/Calm'),
      'lastOutcome': mockElement('Haven\'t bet recently'),
      'emotionalTriggers': mockElement(''),
      'bettingSlip': mockElement(''),
      'history': mockElement(''),
      'notes': mockElement(''),
      'analytical-body': mockElement(),
      'safety-body': mockElement(),
      'recommendation-body': mockElement(),
      'safety-card': mockElement(),
      'recommendation-card': mockElement()
    };
    return elements[id] || mockElement();
  },
  querySelectorAll: () => [{ addEventListener: () => {} }]
};

// Mock fetch for API calls
const fetch = async (url, options) => {
  console.log(`📡 API Call: ${url}`);
  return {
    ok: true,
    json: async () => ({
      advantages: [
        {
          market: {
            event: {
              name: 'New York Rangers @ Utah Mammoth',
              startTime: new Date().toISOString(),
              participants: [
                { name: 'New York Rangers', sport: 'ICE_HOCKEY' },
                { name: 'Utah Mammoth', sport: 'ICE_HOCKEY' }
              ]
            }
          }
        }
      ]
    })
  };
};

// Test functions (extracted from the main code)
function normalize(text) { return (text || '').toLowerCase(); }

function getMockGames(sport) {
  const mockData = {
    'ICE_HOCKEY': [
      {
        home_team: 'New York Rangers',
        away_team: 'Utah Mammoth',
        time: '9:00 PM ET',
        spread: 'Rangers -1.5',
        total: '6.5',
        moneyline: 'Rangers -180, Mammoth +160'
      }
    ],
    'NFL': [
      {
        home_team: 'Kansas City Chiefs',
        away_team: 'Las Vegas Raiders',
        time: '1:00 PM ET',
        spread: 'Chiefs -7.5',
        total: '48.5',
        moneyline: 'Chiefs -350, Raiders +280'
      }
    ],
    'NBA': [
      {
        home_team: 'Boston Celtics',
        away_team: 'Los Angeles Lakers',
        time: '7:30 PM ET',
        spread: 'Celtics -5.5',
        total: '228.5',
        moneyline: 'Celtics -220, Lakers +185'
      }
    ],
    'MLB': [
      {
        home_team: 'Los Angeles Dodgers',
        away_team: 'San Francisco Giants',
        time: '10:10 PM ET',
        spread: 'Dodgers -1.5 (+120)',
        total: '8.5',
        moneyline: 'Dodgers -180, Giants +160'
      }
    ],
    'Soccer': [
      {
        home_team: 'Manchester City',
        away_team: 'Burnley',
        time: '10:00 AM ET',
        spread: 'Man City -2.5',
        total: '3.5',
        moneyline: 'Man City -450, Burnley +900'
      }
    ],
    'Tennis': [
      {
        home_team: 'Novak Djokovic',
        away_team: 'Carlos Alcaraz',
        time: '3:00 PM ET',
        spread: 'Djokovic -3.5 games',
        total: '22.5 games',
        moneyline: 'Djokovic -200, Alcaraz +170'
      }
    ],
    'Basketball': [
      {
        home_team: 'Los Angeles Lakers',
        away_team: 'Golden State Warriors',
        time: '8:00 PM ET',
        spread: 'Lakers -4.5',
        total: '230.5',
        moneyline: 'Lakers -190, Warriors +165'
      }
    ],
    'Football': [
      {
        home_team: 'Green Bay Packers',
        away_team: 'Chicago Bears',
        time: '1:00 PM ET',
        spread: 'Packers -6.5',
        total: '44.5',
        moneyline: 'Packers -280, Bears +240'
      }
    ],
    'Baseball': [
      {
        home_team: 'Atlanta Braves',
        away_team: 'New York Mets',
        time: '7:20 PM ET',
        spread: 'Braves -1.5 (+130)',
        total: '8.0',
        moneyline: 'Braves -160, Mets +140'
      }
    ]
  };
  
  return mockData[sport] || mockData['NFL'] || [];
}

async function fetchSportsData(endpoint, params = {}) {
  try {
    const url = new URL(`https://sportsbook-api2.p.rapidapi.com${endpoint}`);
    Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
    
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'x-rapidapi-host': 'sportsbook-api2.p.rapidapi.com',
        'x-rapidapi-key': process.env.RAPIDAPI_KEY
      }
    });
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Sports API Error:', error);
    return null;
  }
}

async function getCurrentGames(sport) {
  console.log(`🔍 Testing getCurrentGames for sport: ${sport}`);
  
  // Try to get arbitrage data which includes current games and odds
  const arbitrageData = await fetchSportsData('/v0/advantages/', { type: 'ARBITRAGE' });
  
  if (!arbitrageData || !arbitrageData.advantages) {
    console.log(`⚠️  API failed, falling back to mock data for ${sport}`);
    return getMockGames(sport); // Fallback to mock data
  }
  
  console.log(`✅ API succeeded for ${sport}, processing real data`);
  
  // Filter games by sport - the API uses sport names like "ICE_HOCKEY"
  const sportGames = arbitrageData.advantages.filter(advantage => {
    const event = advantage.market?.event;
    if (!event) return false;
    
    // Check participants for sport info
    const participants = event.participants || [];
    if (participants.length > 0) {
      const participant = participants[0]; // First participant
      if (participant.sport) {
        return participant.sport.toLowerCase() === sport.toLowerCase() ||
               participant.sport.toLowerCase().includes(sport.toLowerCase());
      }
    }
    
    // Check competition instance
    const competitionInstance = event.competitionInstance;
    if (competitionInstance?.competition?.sport) {
      return competitionInstance.competition.sport.toLowerCase() === sport.toLowerCase() ||
             competitionInstance.competition.sport.toLowerCase().includes(sport.toLowerCase());
    }
    
    return false;
  }).map(advantage => {
    const event = advantage.market.event;
    const participants = event.participants || [];
    
    // Extract home and away teams
    let homeTeam = 'Unknown';
    let awayTeam = 'Unknown';
    
    if (participants.length >= 2) {
      // Assume first is away, second is home (common format)
      awayTeam = participants[0].name || participants[0];
      homeTeam = participants[1].name || participants[1];
    } else if (event.name) {
      // Parse from event name like "Team A @ Team B"
      const match = event.name.match(/(.+?)\s*@\s*(.+)/);
      if (match) {
        awayTeam = match[1].trim();
        homeTeam = match[2].trim();
      }
    }
    
    return {
      home_team: homeTeam,
      away_team: awayTeam,
      time: event.startTime ? new Date(event.startTime).toLocaleTimeString() : 'TBD',
      spread: 'Check sportsbook', // Would need to parse from outcomes
      total: 'Check sportsbook', // Would need to parse from outcomes
      moneyline: 'Check sportsbook' // Would need to parse from outcomes
    };
  });
  
  return sportGames.length > 0 ? sportGames : getMockGames(sport);
}

// Test all sports
async function testAllSports() {
  const sports = ['ICE_HOCKEY', 'NFL', 'NBA', 'MLB', 'Soccer', 'Tennis', 'Basketball', 'Football', 'Baseball'];
  
  console.log('🏆 Testing all 9 sports...\n');
  
  for (const sport of sports) {
    console.log(`\n🎯 Testing ${sport}:`);
    try {
      const games = await getCurrentGames(sport);
      console.log(`✅ ${sport}: Found ${games.length} games`);
      if (games.length > 0) {
        console.log(`   Sample game: ${games[0].away_team} @ ${games[0].home_team}`);
        console.log(`   Time: ${games[0].time}`);
        console.log(`   Data source: ${games[0].spread === 'Check sportsbook' ? 'Real API' : 'Mock Data'}`);
      }
    } catch (error) {
      console.log(`❌ ${sport}: Error - ${error.message}`);
    }
  }
  
  console.log('\n📊 Testing form auto-population...');
  
  // Test team dropdown population
  const mockSportsData = {
    'ICE_HOCKEY': {
      teams: [
        { name: 'New York Rangers', record: '12-6-2', injuries: 'No major injuries', nextGame: '@ Utah Mammoth' },
        { name: 'Utah Mammoth', record: '8-10-1', injuries: 'Starting goalie questionable', nextGame: 'vs Rangers' }
      ],
      weather: 'Indoor game, 68°F'
    }
  };
  
  function populateTeamDropdowns(sport) {
    const sportData = mockSportsData[sport];
    if (!sportData) return;
    
    console.log(`✅ Team dropdowns populated for ${sport}: ${sportData.teams.length} teams available`);
    sportData.teams.forEach(team => {
      console.log(`   - ${team.name} (${team.record})`);
    });
  }
  
  populateTeamDropdowns('ICE_HOCKEY');
  
  console.log('\n🎉 All tests completed!');
}

// Run the tests
testAllSports().catch(console.error);