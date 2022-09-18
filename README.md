# Crypto Fungi

## Diagram

![diagram](/public/img/crypto-fungi-arch.png)

## Functions

- 새 곰팡이(fungus) 생성
- 먹이 contract 주소 변경하기 (setFeedFactoryAddress)
- 먹이 주기 (feed) → 곰팡이 증식
- 곰팡이 전송하기 (transferFrom)
- 곰팡이 전송 권한 부여하기 (approve)

## How to run

1. 네트워크를 실행하세요. (Ganache, Geth 등)

2. FungusOwnerShip.sol, FeedFactory를 실행한 네트워크에 배포하세요.

3. 배포한 컨트랙트 주소를 복사해서 views/index.ejs 파일을 수정하세요.
   - script 태그 내 startApp 함수 -> cryptoFungiAddress
4. Web3 Provider를 설치하세요. (Metamask, Mist 등)

5. 필요한 패키지를 설치하고(npm install) 애플리케이션을 실행하세요.

6. localhost:3000 접속 후 Web3 Provider를 연동하세요.

7. 트랜잭션을 만들 Account를 연결하고, 충분한 eth가 있는지 확인하세요.

8. 먹이 컨트랙트 주소 변경하기 -> FeedFactory의 주소를 입력하고 실행하세요.

9. FeedFactory에 먹이가 있는지 확인하고, 없으면 createRandomFeed 함수를 실행하여 먹이를 추가해주세요.

10. 이제 Fungus가 먹이를 먹을 수 있습니다.
