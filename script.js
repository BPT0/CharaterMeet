// MBTI 설문조사 데이터
const surveyData = [
    {
        question: "새로운 사람들과 만나는 파티에서 나는?",
        options: [
            { text: "적극적으로 많은 사람들과 대화한다", type: "E" },
            { text: "친한 몇 명과 깊은 대화를 나눈다", type: "I" }
        ]
    },
    {
        question: "데이트 계획을 세울 때 나는?",
        options: [
            { text: "즉흥적이고 새로운 장소를 선호한다", type: "P" },
            { text: "미리 계획하고 체계적으로 준비한다", type: "J" }
        ]
    },
    {
        question: "연인과 갈등이 생겼을 때 나는?",
        options: [
            { text: "논리적으로 문제를 분석하고 해결한다", type: "T" },
            { text: "상대방의 감정을 먼저 이해하려고 한다", type: "F" }
        ]
    },
    {
        question: "이상적인 데이트는?",
        options: [
            { text: "박물관이나 전시회 같은 문화 활동", type: "N" },
            { text: "영화관이나 카페 같은 편안한 장소", type: "S" }
        ]
    },
    {
        question: "연애에서 가장 중요한 것은?",
        options: [
            { text: "서로의 꿈과 목표를 공유하는 것", type: "N" },
            { text: "일상의 작은 행복을 나누는 것", type: "S" }
        ]
    }
];

// MBTI 캐릭터 데이터
const characterData = {
    "ENFP": {
        name: "열정적인 모험가 💫",
        emoji: "🌟",
        description: "자유로운 영혼의 소유자! 새로운 경험을 사랑하고 상대방을 항상 웃게 만드는 매력적인 사람입니다.",
        traits: ["창의적", "열정적", "자유로운", "긍정적"]
    },
    "INTJ": {
        name: "신비로운 전략가 🧠",
        emoji: "🎯",
        description: "깊이 있는 사고와 독립적인 성격의 소유자. 연인과의 미래를 계획하는 것을 좋아합니다.",
        traits: ["독립적", "전략적", "신비로운", "깊이있는"]
    },
    "ESFP": {
        name: "활발한 연예인 🎭",
        emoji: "🎪",
        description: "분위기 메이커! 파티의 중심에서 모든 사람을 즐겁게 만드는 따뜻한 마음을 가진 사람입니다.",
        traits: ["활발한", "따뜻한", "즐거운", "사교적"]
    },
    "ISTJ": {
        name: "신뢰할 수 있는 파트너 🛡️",
        emoji: "🏰",
        description: "책임감 있고 신뢰할 수 있는 사람. 연인을 위해 꾸준히 노력하는 진정한 파트너입니다.",
        traits: ["책임감", "신뢰할 수 있는", "꾸준한", "안정적"]
    },
    "ENFJ": {
        name: "따뜻한 리더 💝",
        emoji: "🤗",
        description: "타인을 배려하고 이끄는 능력이 뛰어난 사람. 연인의 꿈을 응원하고 함께 성장합니다.",
        traits: ["배려심", "리더십", "따뜻한", "성장지향"]
    },
    "INTP": {
        name: "호기심 많은 탐험가 🔬",
        emoji: "🔍",
        description: "지적 호기심이 많고 독특한 관점을 가진 사람. 연인과 깊이 있는 대화를 나누는 것을 좋아합니다.",
        traits: ["호기심", "독특한", "지적", "깊이있는"]
    },
    "ISFP": {
        name: "감성적인 예술가 🎨",
        emoji: "🌸",
        description: "예술적 감성과 따뜻한 마음을 가진 사람. 연인과의 소중한 순간들을 아름답게 기억합니다.",
        traits: ["감성적", "예술적", "따뜻한", "로맨틱"]
    },
    "ENTJ": {
        name: "야심찬 지휘관 👑",
        emoji: "⚡",
        description: "목표 지향적이고 리더십이 강한 사람. 연인과 함께 성공을 향해 나아가는 것을 좋아합니다.",
        traits: ["야심찬", "리더십", "목표지향", "강인한"]
    }
};

// 전역 변수
let currentQuestion = 0;
let answers = [];
let userMBTI = "";

// 설문조사 시작
function startSurvey() {
    currentQuestion = 0;
    answers = [];
    loadQuestion();
}

// 질문 로드
function loadQuestion() {
    const question = surveyData[currentQuestion];
    const progress = ((currentQuestion + 1) / surveyData.length) * 100;
    
    document.getElementById('progress').style.width = progress + '%';
    document.getElementById('question-text').textContent = question.question;
    
    const optionsContainer = document.getElementById('options-container');
    optionsContainer.innerHTML = '';
    
    question.options.forEach((option, index) => {
        const optionElement = document.createElement('div');
        optionElement.className = 'option';
        optionElement.textContent = option.text;
        optionElement.onclick = () => selectOption(option.type);
        optionsContainer.appendChild(optionElement);
    });
}

// 옵션 선택
function selectOption(type) {
    answers.push(type);
    
    // 선택된 옵션 하이라이트
    document.querySelectorAll('.option').forEach(option => {
        option.classList.remove('selected');
    });
    event.target.classList.add('selected');
    
    // 다음 질문으로 이동
    setTimeout(() => {
        currentQuestion++;
        if (currentQuestion < surveyData.length) {
            loadQuestion();
        } else {
            calculateMBTI();
        }
    }, 500);
}

// MBTI 계산
function calculateMBTI() {
    const counts = { E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0 };
    
    answers.forEach(answer => {
        counts[answer]++;
    });
    
    // MBTI 타입 결정
    const mbti = 
        (counts.E >= counts.I ? 'E' : 'I') +
        (counts.S >= counts.N ? 'S' : 'N') +
        (counts.T >= counts.F ? 'T' : 'F') +
        (counts.J >= counts.P ? 'J' : 'P');
    
    userMBTI = mbti;
    window.userMBTI = mbti; // 전역 변수로 저장
    router.navigate('/result');
}

// 결과 표시
function showResult(mbti) {
    const character = characterData[mbti] || characterData["ENFP"]; // 기본값
    
    document.getElementById('character-image').textContent = character.emoji;
    document.getElementById('character-name').textContent = character.name;
    document.getElementById('character-description').textContent = character.description;
    
    const traitsContainer = document.getElementById('character-traits');
    traitsContainer.innerHTML = '';
    character.traits.forEach(trait => {
        const traitElement = document.createElement('span');
        traitElement.className = 'trait';
        traitElement.textContent = trait;
        traitsContainer.appendChild(traitElement);
    });
}

// 매칭으로 이동
function goToMatching() {
    router.navigate('/matching');
}

// 매칭 결과 표시
function showMatchResults() {
    const matchResults = document.getElementById('match-results');
    matchResults.innerHTML = '';
    
    // 간단한 매칭 알고리즘 (실제로는 더 복잡한 로직 사용)
    const matches = generateMatches(userMBTI);
    
    matches.forEach(match => {
        const matchElement = document.createElement('div');
        matchElement.className = 'match-item';
        matchElement.innerHTML = `
            <div class="match-avatar">${match.emoji}</div>
            <div class="match-info">
                <h3>${match.name}</h3>
                <p>${match.description}</p>
            </div>
            <div class="match-score">${match.score}%</div>
        `;
        matchResults.appendChild(matchElement);
    });
}

// 매칭 생성 (간단한 알고리즘)
function generateMatches(userMBTI) {
    const allCharacters = Object.keys(characterData);
    const matches = [];
    
    allCharacters.forEach(mbti => {
        if (mbti !== userMBTI) {
            const character = characterData[mbti];
            const score = calculateCompatibility(userMBTI, mbti);
            
            matches.push({
                name: character.name,
                emoji: character.emoji,
                description: character.description,
                score: score
            });
        }
    });
    
    return matches.sort((a, b) => b.score - a.score).slice(0, 3);
}

// 호환성 계산 (간단한 알고리즘)
function calculateCompatibility(mbti1, mbti2) {
    let score = 50; // 기본 점수
    
    // 같은 성격 유형이면 높은 점수
    for (let i = 0; i < 4; i++) {
        if (mbti1[i] === mbti2[i]) {
            score += 10;
        }
    }
    
    // 랜덤 요소 추가 (실제로는 더 정교한 알고리즘 사용)
    score += Math.floor(Math.random() * 20);
    
    return Math.min(score, 95);
}

// 다시 시작
function restart() {
    router.navigate('/');
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 라우터가 자동으로 초기화됨
});
