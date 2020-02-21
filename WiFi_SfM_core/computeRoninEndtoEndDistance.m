function [endtoEndDistance] = computeRoninEndtoEndDistance(roninResult)

endtoEndDistance = norm(roninResult(1).location - roninResult(end).location);

end