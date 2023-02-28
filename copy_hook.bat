@echo off
rem 使用UTF-8编码
chcp 65001

rem 如果文件已存在，则直接退出，不覆盖原有文件
if exist ".\.git\hooks\pre-commit" (
    echo "pre-commit文件已存在，脚本即将结束执行"  
    pause 
    exit
)


rem 拷贝文件并打印提示信息
copy pre-commit .\.git\hooks
echo "pre-commit文件拷贝已完成"

pause

@echo on