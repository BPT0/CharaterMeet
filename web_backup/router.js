// 라우팅 시스템
class Router {
    constructor() {
        this.routes = {
            '/': 'pages/home.html',
            '/survey': 'pages/survey.html',
            '/result': 'pages/result.html',
            '/matching': 'pages/matching.html'
        };
        this.currentRoute = '/';
        this.init();
    }

    init() {
        // URL 해시 변경 이벤트 리스너
        window.addEventListener('hashchange', () => this.handleRoute());
        
        // 초기 라우트 로드
        this.handleRoute();
    }

    async handleRoute() {
        const hash = window.location.hash.slice(1) || '/';
        const route = this.routes[hash];
        
        if (route) {
            this.currentRoute = hash;
            await this.loadPage(route);
        } else {
            // 404 처리
            this.load404();
        }
    }

    async loadPage(pagePath) {
        try {
            const response = await fetch(pagePath);
            if (response.ok) {
                const html = await response.text();
                document.getElementById('router-container').innerHTML = html;
                
                // 페이지별 초기화 함수 호출
                this.initializePage(hash);
            } else {
                this.load404();
            }
        } catch (error) {
            console.error('페이지 로드 실패:', error);
            this.load404();
        }
    }

    initializePage(route) {
        switch(route) {
            case '/survey':
                this.initializeSurvey();
                break;
            case '/result':
                this.initializeResult();
                break;
            case '/matching':
                this.initializeMatching();
                break;
        }
    }

    initializeSurvey() {
        // 설문조사 초기화
        if (typeof startSurvey === 'function') {
            startSurvey();
        }
    }

    initializeResult() {
        // 결과 화면 초기화
        if (typeof showResult === 'function' && window.userMBTI) {
            showResult(window.userMBTI);
        }
    }

    initializeMatching() {
        // 매칭 화면 초기화
        if (typeof showMatchResults === 'function') {
            showMatchResults();
        }
    }

    load404() {
        document.getElementById('router-container').innerHTML = `
            <div class="screen active">
                <div class="container">
                    <h1>404 - 페이지를 찾을 수 없습니다</h1>
                    <button class="start-btn" onclick="router.navigate('/')">홈으로 돌아가기</button>
                </div>
            </div>
        `;
    }

    navigate(route) {
        window.location.hash = route;
    }

    goBack() {
        window.history.back();
    }
}

// 전역 라우터 인스턴스 생성
const router = new Router();
