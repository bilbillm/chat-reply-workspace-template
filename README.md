[English version](README.en.md)

# TalkTrace

一个帮你整理聊天、看清关系位置、训练真实表达的本地工作区。

<img src="assets/talktrace-logo.png" alt="TalkTrace logo" width="160">

## 安装

复制这个网页的网址粘贴给你电脑上的 LLM / AI / Agent，然后说：

```text
嘿，帮我在我的电脑上装这个东西：
https://github.com/bilbillm/TalkTrace
```

如果它问怎么装，把这段也发给它：

```text
把真实使用的工作区放在我的文档目录下，目录名用 TalkTrace-workspace。
不要让我直接在 GitHub clone 下来的公开仓库里填写真实聊天资料。
安装后先读 START_HERE.md 和 AGENTS.md，再帮我初始化第一个聊天对象。
```

agent 可以直接执行：

```powershell
$repo = Join-Path $env:TEMP "TalkTrace"
if (Test-Path $repo) { Remove-Item -LiteralPath $repo -Recurse -Force }
git clone https://github.com/bilbillm/TalkTrace $repo
powershell -ExecutionPolicy Bypass -File "$repo\scripts\install-talktrace.ps1" `
  -Destination "$HOME\Documents\TalkTrace-workspace"
```

macOS / Linux：

```bash
repo="$(mktemp -d)/TalkTrace"
git clone https://github.com/bilbillm/TalkTrace "$repo"
bash "$repo/scripts/install-talktrace.sh" "$HOME/TalkTrace-workspace"
```

安装完成后，进入工作区并让 agent 读 `START_HERE.md` 和 `AGENTS.md`。

如果你经常觉得“我是不是不会聊天”“我不知道对方到底怎么想”“回复别人好累”“我想变得自然一点”，这个项目是给你准备的。

TalkTrace 不是让你把每一句话都交给 AI 代写，而是把聊天这件事变成可以观察、复盘、练习、迭代的过程。你把聊天记录和自己的感受交给助手，助手帮你整理对象档案、分析当下语境、起草几条更像你的回复，并在你确认后更新本地文档。

## 它能帮你做什么

- 训练自己的聊天技巧，而不是只背话术。
- 在不知道怎么回时，得到 2-3 条可以直接发送的回复。
- 理清你在对方眼中的位置：普通网友、朋友、暧昧对象、交易关系、同事、长期关系等。
- 看清你自己在聊天里是什么样的人：主动还是被动、容易迎合还是容易退开、什么时候会过度用力。
- 把每个聊天对象分开记录，避免把 A 的相处方式套到 B 身上。
- 复盘已经发送的回复：哪些有效，哪些让关系变冷，哪些只是当时看起来“高情商”。

## 适合谁

- 想锻炼与他人聊天，但不知道从哪里练起的人。
- 因为自己的聊天水平不足而难受，想要一个温和但实用的辅助系统的人。
- 跟人聊天容易累，需要先理清关系位置和回复目标的人。
- 希望长期复盘自己表达习惯的人。
- 已经在用 AI 帮忙回复别人，但希望它更像“自己”，而不是通用模板的人。

## 不适合谁

- 想用它操控、诱导、PUA 或压迫别人。
- 想让 AI 替自己判断所有关系，不再承担选择。
- 想通过几句回复强行推进所有关系，尤其是强行暧昧化。
- 想诊断别人、给别人贴固定人格标签，或把对方的性别、性取向、创伤经历当作万能解释。

## 核心思路

TalkTrace 使用“总画像 + 对象隔离”的结构。

`me/` 记录你的总体聊天画像、通用表达习惯、你自己的无意识动力假设和跨对象案例。它回答的是：“我通常怎样说话？我在关系里容易怎么反应？”

`people/<alias>/` 记录某一个聊天对象的独立档案，包括你们的关系定位、对方显性画像、无意识画像、你面对这个对象时的说话风格，以及精选复盘案例。它回答的是：“在这个人面前，我该怎样说才像我，也符合这段关系？”

我们还借用了拉康派精神分析的一些东西，让这个项目更好地处理“对方说了什么”和“对方想被怎样看见”之间的差异。比如欲望、凝视、大他者、缺失、能指、症状和幻想这些概念，可以帮助你识别聊天里反复出现的关系动力。

但这里的精神分析不是诊断工具。所有“无意识画像”都必须写成假设，附上证据、普通话翻译、回复策略和风险。它服务于更稳、更自然的回复，而不是给任何人下定义。

## 目录结构

```text
.
├── AGENTS.md
├── README.md
├── README.en.md
├── assets/
│   └── talktrace-logo.png
├── scripts/
│   ├── install-talktrace.ps1
│   ├── install-talktrace.sh
│   ├── new-person.ps1
│   └── new-person.sh
├── me/
│   ├── profile.md
│   ├── style.md
│   ├── unconscious.md
│   └── cases.md
└── people/
    └── _template/
        ├── profile.md
        ├── persona.md
        ├── unconscious.md
        ├── style.md
        └── cases.md
```

## 怎么使用

1. 用上面的安装命令生成一个本地私用工作区，或者从这个模板创建你自己的私有仓库。
2. 保持真实使用仓库为私有仓库或纯本地目录。
3. 用 `scripts/new-person.ps1 -Alias <对象代号>` 复制 `people/_template/` 为 `people/<对象代号>/`，对象代号不要用真实姓名。
4. 把新的聊天记录、你的第一感受、你想要的关系方向发给助手。
5. 让助手读取 `me/` 和对应对象的 `people/<对象代号>/`，再生成回复建议。
6. 你选择或修改一条回复；收到反馈后，让助手更新对应对象的 `cases.md`，必要时更新 `profile.md`、`style.md` 或 `unconscious.md`。

## 一个虚构例子

```text
对象：小A
关系：普通朋友，最近想拉近一点
对方说：最近真的好累，什么都不想干
我的感觉：想安慰，但怕太用力
```

助手会先读取：

- `me/style.md`：你平时说话长短、语气、表情、禁用词。
- `people/小A/profile.md`：你们现在的关系和边界。
- `people/小A/persona.md`：小A显性上怎么表达、习惯怎样接话。
- `people/小A/unconscious.md`：关于小A关系动力的假设。
- `people/小A/cases.md`：之前哪些回复有效，哪些无效。

然后输出简短建议：

```text
我读这句更像是求接住，不一定是在求解决方案。

不要这样回：
- 直接给建议：“你去运动一下就好了。”
- 过度用力：“我真的好心疼你。”

可选回复：
1. 稳一点：“听起来是累到连处理事情的力气都没了。今天先别逼自己了。”
2. 拉近一点：“那你先瘫一会儿，我在。想说就丢给我，不想说也没事。”
3. 短一点：“先躺着吧，今天不用强撑。”
```

如果你发送了第 2 条，并且小A继续展开说了很多，助手可以把这个案例整理进 `people/小A/cases.md`。如果只是一次普通对话，就不需要保存。

## AI 如何维护档案

默认规则是：助手可以辅助整理，但重要判断需要你确认。

- 明确事实可以直接记录，例如认识时间、地区、关系边界、你已经发送过的回复。
- 假设必须标注为假设，不能写成定论。
- 重要关系判断要先问你，例如“对方是不是在拉近”“这段关系是否降级”“以后是否更适合冷一点”。
- `unconscious.md` 只保存对回复策略有帮助的动力假设，不保存玄学式解释。
- 不保存完整聊天流水，只保存精选原话、你的回复、对方反馈和复盘结论。

## 重要：隐私与安全

这个公开仓库只是模板。真实使用时，请把你的工作区放在私有仓库或本地目录里。

不要提交以下内容到公开仓库：

- 真实姓名、微信号、QQ号、手机号、邮箱、地址。
- 聊天截图、完整聊天流水、原始导出记录。
- 可识别的照片、语音、定位、账单、门票或交易记录。
- 未经对方同意的高度敏感关系细节。

默认 `.gitignore` 只保留 `people/_template/`，会忽略真实的 `people/<alias>/` 目录。这个设计是为了防止你不小心把具体对象档案推到公开仓库。

如果你要用 Git 记录自己的真实复盘，请使用私有仓库，或者只在本地 commit。

## License

MIT
