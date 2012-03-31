if exists("g:load_portmon")
	finish
endif
let g:load_portmon=1
"分析portmon的输出文件
function Portmon()
python3 << EOF
import vim
import os
b=vim.current.buffer
vim.command('new')
vim.command('setlocal buftype=nofile')
vim.command('set bufhidden=hide')
vim.command('set noswapfile')
vim.command('set nobuflisted')
READ='IRP_MJ_READ'
WRITE='IRP_MJ_WRITE'
readstr = ''
writestr = ''

buf=vim.current.buffer
readCnt=0
writeCnt=0
for eachLine in b:
	if READ in eachLine:
		if len(writestr) > 0:
			writeCnt+=1
			buf.append('WRITE:' + writestr)
			writestr = ''
		readstr += eachLine[eachLine.rfind(':') + 1:].strip() + ' '
	elif WRITE in eachLine:
		if len(readstr) > 0:
			readCnt+=1
			buf.append('READ :' + readstr)
			readstr = ''
		writestr += eachLine[eachLine.rfind(':') + 1:].strip() + ' '

buf[0]='Total:write:{0}\tread:{1}'.format(writeCnt,readCnt)
EOF
endfunction

command Portmon :call Portmon()
