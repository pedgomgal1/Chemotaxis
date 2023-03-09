function castingStates = loadTurningOrCastingStates(path)

    load(path);
    idsLarva = vertcat(trx.numero_larva_num);

    mainMatrix=[];
    for nLarv = 1:length(idsLarva)
        lengthT = length(trx(nLarv).run_large);
        mainMatrix = [mainMatrix; [idsLarva(nLarv)*ones(lengthT,1), trx(nLarv).t, trx(nLarv).run_large,trx(nLarv).cast_large,trx(nLarv).turn_large]];

    end
    

    castingStates = [mainMatrix(:,1:2), double(mainMatrix(:,3)==-1)];
end