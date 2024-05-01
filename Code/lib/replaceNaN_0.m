function val = replaceNaN_0(x)
        x(isnan(x))=0;
        val=x;
end