import { v4 as uuidv4 } from 'uuid';
import { Api } from './Api';

export const fetchResult = async (request: chrome.devtools.network.Request) => {
  const rackAnalyzerId = request.response.headers.find((header) => header.name.toLowerCase() === 'x-rackanalyzer-id');
  if (!rackAnalyzerId) return { skip: true };

  const { origin } = new URL(request.request.url);
  const api = new Api({ baseUrl: origin });
  try {
    const response = await api.rackAnalyzerResults.getRackAnalyzerResult(rackAnalyzerId.value);
    return { skip: false, response };
  } catch (e) {
    return { skip: false, response: e };
  }
};

export const fetchResultDebug = async (_request: chrome.devtools.network.Request) => {
  const MOCK_SERVER_ORIGIN = 'http://localhost:8081';
  const api = new Api({ baseUrl: MOCK_SERVER_ORIGIN });
  try {
    const response = await api.rackAnalyzerResults.getRackAnalyzerResult(uuidv4());
    return { skip: false, response };
  } catch (e) {
    return { skip: false, response: e };
  }
};
