# dotfiles

Neovim + Tmux + Ghostty + Mosh 기반의 터미널 개발 환경 설정.
한국어 입력 환경과 원격(SSH/Mosh) 환경에 최적화되어 있습니다.

## 구성

```
dotfiles/
├── setup.sh              # 설치 스크립트
├── nvim/                 # Neovim (LazyVim 기반)
│   └── lua/
│       ├── config/       # 에디터 옵션, autocmd
│       └── plugins/      # 플러그인 설정
├── tmux/.tmux.conf       # Tmux 설정
├── ghostty/config        # Ghostty 터미널 설정
└── mosh/                 # Mosh 설정 및 가이드
```

## 주요 특징

### 한국어 키보드 지원

한글 입력 상태에서도 단축키가 정상 동작하도록 Ghostty, Tmux, Neovim 전체에 한국어 키 매핑이 적용되어 있습니다.

- **Ghostty**: Ctrl/Cmd + 한글 자음 매핑 (ㅁ→A, ㅠ→B, ...)
- **Tmux**: 한글 키 바인딩 (ㅊ→새 창, ㅜ→다음 창, ...)
- **Neovim**: langmap을 통한 한글 명령어 지원

### 원격 환경 클립보드 (OSC 52)

SSH/Mosh 접속 시에도 로컬 클립보드와 연동됩니다. Ghostty, Tmux, Neovim 모두 OSC 52 프로토콜을 지원하며, Mosh 환경에서의 호환성 처리가 포함되어 있습니다.

### Vim-Tmux 통합 내비게이션

`Ctrl+h/j/k/l`로 Vim 분할과 Tmux 패널 사이를 자유롭게 이동할 수 있습니다.

## 도구별 설정

### Neovim

[LazyVim](https://www.lazyvim.org/) 프레임워크 기반으로 구성되어 있습니다.

| 플러그인 | 용도 |
|---------|------|
| github-nvim-theme | GitHub Dark 컬러스킴 |
| mason.nvim | LSP/도구 자동 설치 (tsserver) |
| vim-tmux-navigator | Vim-Tmux 패널 내비게이션 |
| obsidian.nvim | Obsidian 노트 연동 |
| telescope-live-grep-args | 고급 검색 (glob 패턴 지원) |
| git-conflict.nvim | Git 충돌 해결 UI |
| vim-visual-multi | 멀티 커서 (Ctrl+D) |

### Tmux

- **Prefix**: `Ctrl+A` (보조: `Ctrl+Space`)
- **패널 분할**: `|` (수평), `-` (수직)
- **창 전환**: `Option+1~9`
- **세션 전환**: `Option+<` / `Option+>`
- **Vi 모드**: 복사 모드에서 vi 키 바인딩 사용
- **플러그인**: TPM, tmux-sensible, vim-tmux-navigator

### Ghostty

- **테마**: Snazzy
- **폰트**: JetBrainsMonoNL Nerd Font Mono (15pt)
- **한글 폰트**: Noto Sans Mono CJK KR
- **커서**: Block, 깜빡임 없음
- **Option 키**: Alt로 동작 (macOS)

### Mosh

UDP 기반 원격 셸. 네트워크 전환 시에도 세션이 유지됩니다. `.zshenv`를 통해 non-interactive 셸에서도 Homebrew PATH가 설정됩니다.

## 설치

```bash
git clone https://github.com/Sangjun-man/dotfiles.git
cd dotfiles
./setup.sh
```

`setup.sh`가 수행하는 작업:

1. 폰트 설치 (JetBrains Mono Nerd Font, Noto Sans CJK KR)
2. 설정 파일 심볼릭 링크 생성
3. TPM (Tmux Plugin Manager) 설치

설치 후:
- Tmux에서 `prefix + I`를 눌러 플러그인 설치
- Neovim 재시작 시 플러그인 자동 설치

## 요구 사항

- macOS 또는 Linux
- [Neovim](https://neovim.io/) (LazyVim 호환 버전)
- [Tmux](https://github.com/tmux/tmux)
- [Ghostty](https://ghostty.org/)
- [Homebrew](https://brew.sh/) (macOS)
