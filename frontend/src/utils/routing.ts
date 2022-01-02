import {createBrowserHistory} from 'history';

export const history = createBrowserHistory();

export const navigate = (uri: string) => {
	history.push(uri);
	history.go(0);
}