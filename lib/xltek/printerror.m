function printerror(errstr)
if ~isempty(errstr.stack)
    message = arrayfun(@(arg)sprintf('Function:%s @ line %g\n',arg.name,arg.line),errstr.stack,'UniformOutput',false);
    message = ['Error Stack' 10 errstr.message 10 sprintf('%s',message{:})];
    fprintf(2,'\nMessage:%s\n',errstr.message);
    fprintf(2,'%s\n',message);
else
    fprintf(2,'\nMessage:%s\n',errstr.message);
end
