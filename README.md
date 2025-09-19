# How to use dev-branch

## 1. Switching to dev-branch
Local에서 main branch와 연결되어있는 것을 dev-branch로 변경

```
git checkout dev-branch
```

## 2. Commit changes
변경된 내용을 dev-branch 로 내보내기

```
git add .
git commit -m "description of changes"

git push origin dev-branch
```

## 3. Pull request
GitHub 홈페이지로 들어와 dev-branch에 있는 내용을 main branch로 pull-request 진행

> (1) GitHub 저장소 페이지로 이동하여 Pull requests 탭을 클릭\
> (2) 초록색 New pull request 버튼을 클릭\
> (3) 합칠 브랜치를 선택(main)\
> (4) Create pull request 버튼을 눌러 pull request를 요청\
> (5) 변경 내용 검토 후, 문제가 없다면 초록색 Merge pull request 버튼을 눌러 병합을 완료\

## 4. Update main branch
GitHub에서 업데이트된 main 브랜치의 내용을 로컬 환경에서도 동기화

```
git checkout main
git pull origin main
```
