function averageLarvaLength = calculateAverageLarvaeLength(dataSpine)
    arraydist1 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,3),dataSpine(:,4),dataSpine(:,5),dataSpine(:,6));
    arraydist2 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,5),dataSpine(:,6),dataSpine(:,7),dataSpine(:,8));
    arraydist3 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,7),dataSpine(:,8),dataSpine(:,9),dataSpine(:,10));
    arraydist4 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,9),dataSpine(:,10),dataSpine(:,11),dataSpine(:,12));
    arraydist5 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,11),dataSpine(:,12),dataSpine(:,13),dataSpine(:,14));
    arraydist6 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,13),dataSpine(:,14),dataSpine(:,15),dataSpine(:,16));
    arraydist7 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,15),dataSpine(:,16),dataSpine(:,17),dataSpine(:,18));
    arraydist8 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,17),dataSpine(:,18),dataSpine(:,19),dataSpine(:,20));
    arraydist9 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,19),dataSpine(:,20),dataSpine(:,21),dataSpine(:,22));
    arraydist10 = arrayfun(@(p1,p2,p3,p4) pdist2([p1 p2],[p3,p4]),dataSpine(:,21),dataSpine(:,22),dataSpine(:,23),dataSpine(:,24));
    
    totalSum = arraydist1+arraydist2+arraydist3+arraydist4+arraydist5+arraydist6+arraydist7+arraydist8+arraydist9+arraydist10;
    averageLarvaLength = mean(totalSum);
end