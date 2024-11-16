function pdftex(f,name,mat)
if nargin < 3
        mat = []; % 初始化为空的占位符
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 这是一个可以把简单的数学公式生成pdf的函数(暂时还不支持数组)  
% 参数：                                                   
% f      --你要转换的公式                                   
% 'name' --想要转换的名字                               
% 注意！                                                  
% 这需要你在此电脑上安装了任何tex编辑工具                     
% 并且存在与系统变量                                        
% 推荐你使用MikTeX                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
latex_str = latex(f);

if ~isempty(mat)
    %我在之后加入将数族转化为矩阵的功能
end
% 将 LaTeX 字符串写入 .tex 文件
        tic 
        tex_content = sprintf('\\documentclass{article}\n');
        tex_content = [tex_content sprintf('\\begin{document}\n')];
        tex_content = [tex_content sprintf('$')];
        tex_content = [tex_content latex_str ];
        tex_content = [tex_content sprintf('$\n')];
        tex_content = [tex_content sprintf('\\end{document}')];
        disp('生成.tex文件成功')
        toc

        tic
        disp('正在写入.tex')
        filename = strcat(name, '.tex');  % 拼接文件名
        fid = fopen(filename, 'w');
        if fid == -1
            error('无法打开文件进行写入: %s', filename);
        end
        fprintf(fid,'%s', tex_content);
        fclose(fid);
        disp('写入成功')
        toc

        tic
        disp('正在编译 LaTeX 文件生成 PDF')
        disp('使用 system 函数调用 pdflatex 命令')
        disp('注意: 确保 pdflatex 在系统的 PATH 环境变量中')
    
        [status, cmdout] = system(sprintf('pdflatex %s', filename));
        if status ~= 0
            error('LaTeX 编译失败:\n%s', cmdout);
        end
        toc

        tic
        disp('删除多余的辅助文件')
        delete(sprintf('%s.aux', name));
        delete(sprintf('%s.log', name));
        toc
        disp('完成!')
        open(sprintf('%s.pdf', name))
        
end