# 内容更新指南

网站的高频内容集中在 `_data/*.yml`。日常更新通常只需要编辑对应的数据文件；只有调整页面布局、栏目结构或视觉样式时，才需要修改 `_pages/`、`_includes/` 或 `_sass/`。

## 快速索引

| 要更新的内容 | 数据文件 |
| --- | --- |
| 姓名、简介、头像、主页与页脚链接 | `_data/profile.yml` |
| 首页研究概览、Join Us | `_data/home.yml` |
| Recent Updates 与完整 News | `_data/news.yml` |
| Research 总述、关系图、主题和 related work | `_data/research.yml` |
| Current / Past Courses | `_data/teaching.yml` |
| Student Achievements 与 Alumni | `_data/students.yml` |
| Editorial、Conference、Journal Service | `_data/services.yml` |
| Talks and Presentations | `_data/talks.yml` |
| Selected Publications 卡片 | `_data/selected_publications.yml` |
| Full Publication List | `_data/publications.yml` |

YAML 使用两个空格缩进，不使用 Tab。包含冒号、井号或特殊符号的短文本建议用双引号包住；较长段落使用 `>-`。更新有顺序的数据时，把最新条目放在最前面。

## 常用更新样例

### 1. 添加一条 News，并在首页显示

在 `_data/news.yml` 的 `items:` 下按时间倒序插入：

```yaml
  - date: "2026-08-15"
    display: Aug 2026
    featured: true
    summary: >-
      Two papers were accepted to **NeurIPS 2026**.
    content: >-
      Two papers were accepted to **NeurIPS 2026** on [topic A](https://example.com/a) and [topic B](https://example.com/b).
```

- `featured: true`：参与首页 Recent Updates 的展示；首页只取最新五条 featured news。
- `summary`：可选，首页使用的精简版；News 页面始终使用 `content`。
- `date`：支持 `YYYY`、`YYYY-MM` 或 `YYYY-MM-DD`，并用于排序与 HTML 时间语义。

### 2. 学期结束后更新 Teaching

把已经结束的课程从 `current:` 移到 `past:` 最上方，再填写新学期课程：

```yaml
current:
  - term: 2027 Spring
    code: AIAA 1234
    title: Example Course

past:
  - term: 2026 Fall
    code: AIAA 3111
    title: Introduction to Data Mining
```

同一学期、同一课程代码不能重复。

### 3. 添加 Student Achievement

在 `_data/students.yml` 的 `achievements:` 中按年份倒序插入：

```yaml
  - name: Student Name
    year: 2027
    award: HKUST(GZ) AI Thrust 2027 Best Research Award
    url: https://example.com/award
```

`url` 可省略。显示时保持“姓名 + 奖项名称”的现有格式，`year` 主要用于校验排序。

### 4. 添加 Alumni

学生加入 `alumni.students`：

```yaml
    - name: Student Name
      degree: Ph.D.
      year: 2027
      destination: Assistant Professor, Example University
```

RA、intern 或 visiting student 加入 `alumni.assistants`：

```yaml
    - name: Student Name
      role: Research Assistant
      background: Undergraduate, Example University
      destination: Ph.D. student, Example University
```

`destination` 对 RA / intern 可省略。

### 5. 更新 Research theme

修改 `_data/research.yml` 中对应 theme；页面标题、介绍、配图和 related work 会同步更新：

```yaml
  - id: grounded-physical-agents
    title: Grounded Physical Agents
    image: /images/research/grounded-physical-agents.svg
    description: >-
      A concise description of the theme.
    related:
      - title: Project Name
        url: https://arxiv.org/abs/0000.00000
```

`id` 同时作为页面锚点，应保持稳定；除非主题本身改名，不建议修改。

### 6. 更新 Join Us

在 `_data/home.yml` 的 `join.opportunities` 中编辑或增加卡片：

```yaml
    - title: Visiting students
      content: >-
        A concise description with an [application link](https://example.com/).
```

`content` 支持 Markdown 链接、粗体和斜体。

### 7. 添加 Talk

在 `_data/talks.yml` 顶部按日期倒序加入：

```yaml
  - title: Example Talk
    format: Invited Talk
    venue: Example Conference
    venue_url: https://example.com/
    location: Guangzhou, China
    date: "2027-01-15"
```

`venue_url` 和 `location` 可省略。

### 8. 添加 Selected Publication

在 `_data/selected_publications.yml` 的相应主题 `papers:` 下加入卡片：

```yaml
    - short_title: Project Name
      venue: KDD 2027
      topic: Agentic data science
      title: "Full Paper Title"
      url: https://arxiv.org/abs/0000.00000
      bibtex: /files/bibtex/project-name.bib
      image: /images/publications/project-name.png
      image_alt: Brief factual description of the figure
      authors: "First Author and <strong>Hao Liu</strong>"
      summary: "One sentence explaining the problem, approach, and contribution."
      links:
        - label: Code
          url: https://github.com/usail-hkust/project-name
```

同时需要：

1. 把 BibTeX 文件放入 `files/bibtex/`；
2. 把卡片图片放入 `images/publications/`；
3. 在 `_data/publications.yml` 相应年份中加入完整引用。

如果没有 code、demo 或 project page，可省略 `links`。`image_alt` 应描述图片内容，而不是重复论文标题。

## 更新后检查

```bash
bundle exec jekyll build --destination /tmp/raymondhliu-site
ruby scripts/validate_content.rb
ruby scripts/validate_publications.rb
ruby scripts/validate_site.rb /tmp/raymondhliu-site
```

校验会检查必填字段、日期排序、重复条目、本地文件、链接格式、论文附件，以及 YAML 条目是否完整渲染到生成页面。最后在桌面端和移动端各快速查看首页、Research、Publications 和本次修改的页面。
