function logPrior = gaussLogPrior(m,extras)


% problemDef = extras{1};
% problemDef_cells = extras{2};
% problemDef_limits = extras{3};
% controls = extras{4};
priorList = extras.priors;

% All are in range, so check for Gaussian priors....
% We pick out any priors that are Gaussians and calculate the mvnpdf
gaussPriors = find(strcmpi(priorList(:,1),'gaussian'));

if ~isempty(gaussPriors)    % There may be no Gaussian priors defined!
    mus = [priorList{gaussPriors,2}];
    sigs = [priorList{gaussPriors,3}];
    pdf = mvnpdf(m(gaussPriors),mus,sigs);
    logPrior = pdf;%log(pdf);
else
    logPrior = 0;
end

end