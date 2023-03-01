# 一、Git常见使用方法

## 1. 忽略文件

* 修改文件
    - 修改`.gitignore`文件，需要提交到git仓库
    
    - 修改`.git/info/exclude` 文件，不需要提交到git仓库，可以用来忽略个人的一些测试文件，只能忽略没有被git跟踪的文件，根目录从`.gitignore`所在目录开始，例如：`/test.txt`或`test.txt`都是忽略`test.txt`文件，不能是`./test.txt`；和文件夹没关系，例如给`.git/info/exclude` 文件添加一行`/folder`，只会对`/floder`文件夹内的本地文件生效。

* 命令行

`git update-index --assume-unchanged FILE_NAME`忽略git已经跟踪的FILE_NAME文件，只能忽略文件不能是文件夹

`git update-index --no-assume-unchanged FILE_NAME`恢复跟踪FILE_NAME文件

* git stash

可以将测试的代码 放入stash，然后使用的时候`git stash apply`具体使用方法可以查看后文

## 2.查看作者

* 查看分支创建作者（git不能获取分支的创建者）

分支只是一个提交指针，并不会保存作者信息，因此没法获取分支的创建者

`git for-each-ref --format='%(committerdate) %09 %(authorname) %09 %(refname)'`

`git for-each-ref --sort=authordate --format='%(authorname) %(refname)' refs/remotes`只能输出该分支最后一次commit的作者是谁，并不能输出由谁创建该分支

.git\refs\heads\BRANCH文件就是BRANCH分支的最后一次提交id

* 查看FILE文件每一行是由谁最后提交的

`git blame FILE` 

## 3.git钩子

[Hello Git（六）——Git钩子_git 钩子_天山老妖的博客-CSDN博客](https://blog.csdn.net/A642960662/article/details/123088970)

服务器端钩子在某些服务器中是不允许使用的，可以把钩子保存在仓库的某个地方，然后创建一个脚本把它们复制到`.git/hooks`目录中。

# 二、Git常用关键字

## 1.HEAD

`cat .git/HEAD`查看当前HEAD指针

`git symbolic-ref HEAD` 查看指针指向（HEAD指向一个引用时）

## 2.blob tree commit

[【git】blob、tree、commit](https://blog.csdn.net/u010900754/article/details/110724492?spm=1001.2101.3001.6650.6&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-6-110724492-blog-103882618.pc_relevant_antiscanv2&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-6-110724492-blog-103882618.pc_relevant_antiscanv2&utm_relevant_index=12)

# 三、Git常见错误解决方法

##  <a name="git_pull">1.git pull提示错误</a>

* git提示：

```bash
Your branch and 'origin/master' have diverged,
(use "git pull" to merge the remote branch into yours)
nothing to commit, working tree clean
```

* 解决方法(BRANCH是远程分支名)：

```bash
git fetch origin
git reset --hard origin/BRANCH
```

# 四、Git常用命令

## git log

`git log --graph` 图形显示log

`git log --pretty=oneline`仅显示版本hash值和注释，`=`两边不要加空格

`git log --oneline`仅显示版本hash值前8位和注释

`git log BRANCH`查看BRANCH分支的log

`git log --oneline B`或`git log B --oneline` 查看B分支的log，仅显示版本hash值前8位和注释

`git log -n NUM`仅显示最近的NUM条log（可以配合重定向符将log打印到文件中，例如`git log -n 10 > log.txt`将最近的10条log打印到文件log.txt）

## git branch

`git branch` 查看当前分支

`git branch -f BRANCH C_ID `将BRANCH分支强制指向C_ID(C_ID可以是commit id，也可以是HEAD指针，甚至可以是分支名。如果是分支名，就相当于将两个分支保持完全一致。执行该命令必须在非BRANCH分支下执行，在BRANCH分支下执行`git reset --hard C_ID`和该命令效果一致。有时和git rebase 也有相同的效果)

`git branch –d NAME`删除本地分支NAME

`git branch -m NAME`将当前分支的名称修改为NAME（修改的是本地分支）。修改远程仓库的分支名，可以将远程原分支删除，然后将新的分支推送上去，再重新设置上游分支。完整步骤（old是原分支名，new是新分支名）：`git branch -m old new` -> `git push origin :old new` -> `git push -u origin new`

`git branch -m name newName`将分支name改为newName

`git branch --set-upstream-to B origin/B`将本地的B和远程的B进行关联，设置过关联之后我们只需要git push和git pull就可以更新和推送这个分支了，不然推送新的分支到远程之后，不能直接对这个新的远程分支进行git push操作

* 查看本地分支基于那个分支创建

`git reflog B`或`git reflog show B`show是缺省值，B是分支名，仅适用于查看从**远程分支**checkout到本地的分支，如果是本地直接新建分支，则仅仅展示create from HEAD，不能获取到从哪个分支创建。可以查看对该分支进行了那些操作，即git命令

`git reflog show --date=local | grep B`查看merge、checkout、rebase等操作的记录，可以看到分支B是从那个分支创建的（grep使用方法自行查阅）

`git reflog`并不是git仓库的一部分，它完全是属于本地的东西（git clone之后用户所有在本地的操作），.git/logs/HEAD文件或.git/logs/refs目录中的文件的内容就是`git reflog`命令的结果，所有引起HEAD指针变化的操作都会被存储在这些文件中

## git tag

`git tag TAG_NAME COMMIT_ID`创建一个tag，并让它指向COMMIT_ID(如果不指定comiit_id，默认使用HEAD)

## git restore

`git restore --staged NAME_FILE` 如果刚才对NAME_FILE进行了`add`操作可以执行该命令，撤销add操作，即将暂存区的文件恢复到工作区，修改的内容还存在（如果已经commit该命令无效）

`git restore -- FILE_NAME`将本地修改的FILE_NAME文件恢复，如果已经对该文件执行add则无效

## git switch

切换分支

`git switch B`切换到分支B

`git switch -c B` （create）创建并切换到分支B

`git switch -c B C_T`以一个commit id或tag来创建一个分支B，并切换到分支B

`git switch -d C`（detach）切换到某一个commit id C但是不创建新的分支，可以查看这个记录之前的修改情况

`git switch --orphan B`创建一个没有任何提交记录的分支B，删除所有跟踪文件

`git switch -`切换到上一个分支，例如刚才从B切换到当前分支，使用该命令会切换到B分支


## git checkout

**git checkout 是git restore和git switch的集合**

`git checkout commitID`将HEAD指针指向commitID

`git checkout -b BRANCH COMMIT_ID`  从COMMIT_ID新建一个分支BRANCH

`git checkout TAG_NAME` 将HEAD指针指向TAG_NAME

`git checkout COMMIT_ID` 将HEAD指针指向COMMIT_ID

`git checkout -- FILE_NAME`将文件FILE_NAME修改的内容撤销，适用于还没使用`add/commit`等命令时，`--`两边都有一个空格，可以用`.`代替FILE_NAME，如果不小心删除了本地文件，也可以用此命令恢复

`git checkout B -- FILE_NAME`可以把当前分支中的FILE_NAME文件切换成B分支中的文件

**设置远程跟踪（remote tracking)的两种方法**

+ `git checkout -b newB origin/main` 从远程仓库中的main检出一个newB分支

+ `git branch -u origin/mian BRANCH` 让BRANCH分支跟踪远程main分支，如果当前就在BRANCH分支，可以省略BRANCH

## git rebase

`git rebase BRANCH` 将BRANCH分支添加到当前分支的前面，就是将HEAD指针指向最新的提交（例如B1是从B创建的，B提交了很多内容，B1没有做任何更改，在B1分支下使用git rebase B，就会将B的所有更改同步到B1，此时B和B1完全一样）BRANCH可以是分支名，也可以是COMMIT_ID(会把当前分支中两个分支同一个父节点之后的所有COMMIT都添加到当前分支)注意和git cherry-pick区别：两个命令操作的当前分支不同，rebase 的 BRANCH不会改变，当前分支会变化，cherry-pick是把COMMIT_ID复制到当前分支下，所以当前分支也会变化

`git rebase B1 B2` 将B2分支附加到B1分支的后面，（会将B2分支中，从两个分支同一个父节点之后的所有commit添加到B1后面），和`git switch B2 + git rebase B1`一样

`git rebase -i HEAD~3` 修改当前分支最近3次的提交记录(HEAD~n 最近n次，在打开的编辑器中先提交的在最上面，即最下面的commit是最新的提交)，如果不需要做任何修改，只需要关闭打开的编辑器，然后`git pull --rebase`，请勿使用`git pull`，如果要修改远程的提交记录，`git rebase -i`之后需要`git push -f`将本地的commit强制推送到远程

* record 修改提交注释，不修改提交内容，关闭编辑器后会打开一个新的编辑器，输入新的注释保存并关闭（如果只是修改最近一次的提交记录可以使用`git commit --amend -m M`）
* edit 修改提交内容，关闭编辑器后会进入`(BRANCH_NAME|REBASE-i m/n)`修改文件后`git add ;git commit -m`然后`git rebase --continue`即可
* pick 不做任何修改
* squash 合并提交，将多个commit合并为一个，会将该commit合并到上面的commit中
* fixup 和squash相似，会将注释丢弃，使用较早的注释描述合并的提交记录
* drop 删除该commit，直接将这一行删除也可以删除该条commit

例如将最近三次提交合并为一个：`git rebase -i HEAD~3`在编辑器中最上面的pick不变，下面两个pick改为squash，保存之后会再打开一个编辑器，此时输入的是新的注释。修改完注释保存，即可将最近三个commit合并为一个

例如将最近的第三次提交修改：`git rebase -i HEAD~3` 进入编辑器之后将第一行的pick改为edit后保存文件，此时可以对这次提交的内容进行修改（就相当于进入了提交本次commit之前的状态），修改完之后`git add .`将修改的内容保存到暂存区，然后使用`git commit --amend`对本次提交的注释进行修改，修改完保存文件，然后使用`git rebase --continue`完成本次修改（执行完该命令可能会有冲突，解决完冲突后使用`git add .`再使用`git rebase --continue`即可完成）

## git merge

`git merge BRANCH` 将BRANCH合并到当前分支，只能带一个参数

## git push

`git push origin B`将本地的B分支推送到远程，远程分支名为B，如果本地没有B分支会报错。并不会将远程分支和本地分支进行关联（只是让远端有了一个B分支），即如果要对B分支进行`push`等操作还需要设置上游分支`git push --set-upstream origin B`或`git push -u origin B`

`git push origin B:B`或`git push origin B`或`git push`如果当前分支是B时，这三个等价，都是将本地的B分支推送到远程的B分支

`git push origin --delete NAME`或`git push origin -d NAME`直接删除远程分支NAME,不需要将NAME分支拉到本地

`git push origin :B1 B2`将B2分支推送到远程仓库，并删除远程仓库的B1分支

## git fetch

当你克隆时, Git 会为远程仓库中的每个分支在**本地仓库中**创建一个远程分支（比如 `origin/main`）。然后再创建一个跟踪远程仓库中活动分支的本地分支，默认情况下这个本地分支会被命名为 `main`。`git fetch`就是将远程的提交拉取到本地的远程分支`origin/NAME`

`git fetch origin BRANCH` 从远程的BRANCH分支获取本地不存在的提交，放到本地的BRANCH远程分支上，下载完之后可以使用`git status`查看

`git fetch` 没有任何参数，会下载所有的提交记录到本地的各个远程分支

`git fetch origin :BRANCH` 会在本地创建一个BRANCH分支

**一般git使用流程：**`git fetch` -> `git rebase origin/BRANCH_NAME`-> `git push`

## git pull

`git pull`是`git fetch`和`git merge origin/C_B`的简写(C_B是当前分支的名字，origin/C_B表示本地的远程分支C_B)

`git pull --rebase` 是 `git fetch` 和 `git rebase` 的简写

`git pull origin B` 相当于`git fetch origin B;git merge B`

`git pull origin B1:B2`相当于 `git fetch origin B1:B2;git merge B2`

## git remote

`git remote -v`显示远程仓库的地址（可以查看url是http还是ssh）

`git remote prune origin`同步远程分支，将远程已经删了的分支本地也删除（删除的是本地的远程分支，不是本地的本地分支，本地的本地分支可以使用`git branch -d NAME`来删除）

## git diff

`git diff C1 C2` 比较两个commit id ：C1 和 C2的区别

`git difftool c1 c2`使用工具比较两个commit的区别

`git diff B1 B2 --stat` 比较分支B1和分支B2，本地未提交的内容不会比较 ，本地已经commit的内容才会比较

`git difftool origin/B` 使用比较工具和远程分支B比较，会将所有的差异一个一个显示出来（可以修改git安装目录下etc/gitconfig文件的前两行，将比较工具设置为compare3，具体方法百度一下）

## git commit

`git commit -m M`提交暂存区(使用 `git add`会提交到暂存区）到仓库区，M是注释，注释需要加上`''`（如果注释没有空格换行等字符，可以不加`''`,建议都加上）
`git commit -a`提交工作区与暂存区的变化直接到仓库区，不能将新建的文件添加到暂存区或仓库区
`git commit -v`提交时显示所有 diff 信息

`git commit --amend -m M` 提交暂存区修改到仓库区，合并到上次修改，并修改上次的提交信息（使用新的注释M覆盖上一次注释，修改的是本地的commit，如果要同步到远程，需要使用`git push -f`强推，拉取代码出现错误请看前文[git pull提示错误](#git_pull)）
`git commit --amend --no-edit` 和`git commit --amend -m M`的区别是这个命令不需要添加注释，即仍然使用上次的注释，如果上一次提交有漏提交的文件可以使用该命令，比如第一次commit只提交了文件file1，但是file2漏提交了，这时就可以用此命令，log记录还是上一次的Message，id也是上一次的

## git reset

`git reset --hard HEAD^`撤销最近一次的commit，例如对某一文件进行了修改并执行了add和commit操作，执行完该命令之后，修改过的文件会恢复到上一版本的内容，本地修改的内容会被覆盖谨慎使用，`HEAD^`指上一次的commit id， `HEAD`指最近一次的commit id

`git reset --hard COMMIT_ID`恢复到COMMIT_ID对应的历史，不建议使用

`git reset --soft HEAD^`撤销最近一次的commit，不会撤销add操作，保留最近一次的commit内容（即最近一次commit的内容会恢复到本地）`HEAD^`表示最近一次，如果要恢复多次请使用`HEAD~i`，i表示最近几次
`git reset HEAD^`相当于`git reset --mixed HEAD^`撤销最近一次的commit并且撤销add，修改的内容还会保存在本地

`git reset --hard B`将当前分支修改为和B分支完全一样，相当于基于B分支创建了一个新的当前分支，需要使用`git push -f`强制推到远程

## git revert


revert 可以撤销指定的提交内容，撤销后会生成一个新的commit

`git revert COMMIT_ID`撤销COMMIT_ID对应的提交，并将此次操作生成一个新的commit id

`git revert C1 C2 C3`撤销多个commit id

`git revert C1...C2`撤销C1到C2之间的所有提交，不包括C1包括C2

`git revert -n C`或`git revert --no-commit C`：撤销commit id为C的提交，但执行命令后不进入编辑界面，也就是不会自动帮你提交文件，需要手动提交，和`git revert C`的区别就是撤销和提交分开了

## git revert和git reset区别

+ `git revert `是用一次新的commit来回滚之前的commit，此次提交之前的commit都会被保留；

+ `git reset`是回到某次提交(HEAD指向某次提交），指定的commit以及之前的commit都会被保留，但是此commit id之后的修改都会被删除

## git cherry-pick

`git cherry-pick COMMIT_ID1 COMMIT_ID2...` 将列出来的所有commit id全部复制到当前分支，cherry-pick 可以将提交树上任何地方的提交记录取过来追加到 HEAD 上，不管在那个分支都不会有重复的commit id，**操作完成后前面的COMMIT_ID是后面的父级，即ID1是ID2的父级。**注意**合并冲突**

`git cherry-pick C1...C2`将C1之后C2之前的所有commit id复制到当前分支，不包括C1包括C2，即(C1,c2]

### 参数
* `-n`或`--no-commit`

只更新工作区和暂存区，不产生新的提交

* `-x`

在提交信息的末尾追加一行`(cherry picked from COMMIT_ID)`，方便以后查到这个提交是如何产生的。

## git stash

注意：

**git stash只会操作被git跟踪的文件，新添加的文件如果没有进行git add操作不会放到stash里面，stash是所有分支共用的**

**以下所有命令中的ID都可以省略，stash是栈结构，如果没有指定ID则会对最后一次添加的stash进行操作**

`git stash` 将当前的进度保存

`git stash save M`将当前的进度保存，并添加注释M

`git stash pop ID`将ID（stash@{$0、1、2......}或者数字0、1、2……）对应的stash弹出，如果和本地文件冲突，需要解决冲突（会从stash列表中删除）

`git stash drop ID`删除一个ID对应的stash

`git stash clear`清除所有stash

`git stash show ID`显示ID对应的stash和当前分支的差别（本地add,commit的内容不会比较，应该是和远程的当前分支比较，暂不确定），`git stash show ID -p`会列出详细更改

`git stash branch B`创建一个新的分支B，并将stash应用到该分支，相当于`git checkout -b B;git stash apply`

`git stash apply ID`与pop相似，但他不会在stash栈中删除这条缓存，适合在多个分支中进行缓存应用

**误删git stash解决方法：**

`git fsck --lost-found` 会列出很多操作ID（fsck = file system check，网上说最新的在最上面，实际测试好像不是这样，建议从最下面依次查看更改内容，再根据需要恢复）

`git show ID`显示该ID的更改内容

`git stash apply ID`将该ID对应的stash恢复到本地

## git show

`git show COMMIT_ID`显示COMMIT_ID提交了那些内容

## 子模块

### 添加子模块

`git submodule add url path` 例如在当前仓库的`SubModule`目录下添加子模块`testCPP `，`git submodule add git@github.com:Yangpan08/testCPP.git SubModule/testCPP`

然后将之前的操作提交到远程仓库即可：`git add .`，`git commit -m "注释：添加子模块"`，`git push`

如果报错：

```
fatal: A git directory for 'xxx' is found locally with remote(s):
  origin        xxx
If you want to reuse this local git directory instead of cloning again from
  xxx
use the '--force' option. If the local git directory is not the correct repo
or you are unsure what this means choose another name with the '--name' option.
```

将`.git/modules`目录下对应的文件夹删除，如果还报错请执行：`git rm -r --cached XXX`将对应的子模块缓存删除

### 拉取子模块

- 首次克隆仓库：`git clone --recursive url`url是仓库的地址
- 已经拉取了父仓库，子模块没有拉取 `git submodule update --init --recursive`，`git pull --recurse-submodules`

### 更新子模块

- 在父目录中操作

```shell
$ git submodule update              // 与主仓库中的子模块代码同步
$ git submodule update --remote     // 与子仓库中代码同步（同步所有的子模块）
$ git submodule update --remote xxx // 指定需要同步的子模块
```

- 在子模块目录中操作

`git pull`

### 设置子模块的分支

`git config -f .gitmodules submodule.SubModuleName.branch BranchName`将子模块`SubModuleName`的分支指定为`BranchName`，子模块名可以在`.gitmodules`文件查看

`git submodule set-branch -b BranchName Path` `BranchName`是需要设置的分支名，`Path`是需要指定分支的子模块名，就是`.gitmodules`中的path

设置了分支，拉取的子模块还是没有更改分支，不知为何，后续再改
