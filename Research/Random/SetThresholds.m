function [hueThresholdLow, hueThresholdHigh, saturationThresholdLow, saturationThresholdHigh, valueThresholdLow, valueThresholdHigh] = SetThresholds()
			% Green
			hueThresholdLow = 0.15;
			hueThresholdHigh = 0.60;
			saturationThresholdLow = 0.36;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0;
			valueThresholdHigh = 0.8;
end