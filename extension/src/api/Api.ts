/* eslint-disable */
/* tslint:disable */
/*
 * ---------------------------------------------------------------
 * ## THIS FILE WAS GENERATED VIA SWAGGER-TYPESCRIPT-API        ##
 * ##                                                           ##
 * ## AUTHOR: acacode                                           ##
 * ## SOURCE: https://github.com/acacode/swagger-typescript-api ##
 * ---------------------------------------------------------------
 */

export interface RackDevInsightResultSchema {
  /**
   * @format uuid
   * @example "123e4567-e89b-12d3-a456-426614174000"
   */
  id: string;
  /**
   * Http status code
   * @format int32
   * @example 200
   */
  status: number;
  /**
   * Http method
   * @example "GET"
   */
  method: string;
  /**
   * Http path
   * @example "/api/v1/users"
   */
  path: string;
  /**
   * Request duration in milliseconds
   * @format float
   * @example 10
   */
  duration: number;
  sql: SqlSchema;
  /** Api requests and responses */
  apis: ApiSchema[];
}

export interface SqlSchema {
  /** @example [{"id":1,"type":"CREATE","table":"users","count":1,"duration":10,"queryIds":[1]},{"id":2,"type":"READ","table":"users","count":1,"duration":10,"queryIds":[2]},{"id":3,"type":"UPDATE","table":"users","count":1,"duration":10,"queryIds":[3]},{"id":4,"type":"DELETE","table":"users","count":2,"duration":30,"queryIds":[4,5]}] */
  crudAggregations: CrudAggregationSchema[];
  /** @example [{"id":1,"statement":"INSERT INTO users (first_name, last_name, email, password, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW()), (?, ?, ?, ?, NOW(), NOW()), (?, ?, ?, ?, NOW(), NOW())","count":1,"duration":10,"queryIds":[1]},{"id":2,"statement":"SELECT * FROM users WHERE id = ?","count":1,"duration":10,"queryIds":[2]},{"id":3,"statement":"UPDATE users SET name = ? WHERE id = ?","count":1,"duration":10,"queryIds":[3]},{"id":4,"statement":"DELETE FROM users WHERE id = ?","count":2,"duration":30,"queryIds":[4,5]}] */
  normalizedAggregations: NormalizedAggregationSchema[];
  /** @example [{"id":1,"message":"Syntax error","statement":"SELECT * FROM users WHERE id = 2","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10},{"id":2,"message":"Parser error","statement":"UPDATE users SET name  = 'Jack' WHERE id = 1","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10},{"id":3,"message":"Parser error","statement":"DELETE FROM users WHERE id = 1","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10}] */
  erroredQueries?: ErroredQuerySchema[];
  /** @example [{"id":1,"statement":"INSERT INTO users (first_name, last_name, email, password, created_at, updated_at) VALUES\n('John', 'Doe', 'john.doe@example.com', 'johnspassword', NOW(), NOW()),\n('Jane', 'Doe', 'jane.doe@example.com', 'janespassword', NOW(), NOW()),\n('Jim', 'Beam', 'jim.beam@example.com', 'jimspassword', NOW(), NOW());\n","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15},{"original":"app/models/user.rb:120:in `normalize_name'","path":"app/models/user.rb","line":120},{"original":"app/helpers/user_helper.rb:10:in `formatted_name'","path":"app/helpers/user_helper.rb","line":10},{"original":"app/views/users/show.html.erb:15:in `_app_views_users_show_html_erb__1234567890'","path":"app/views/users/show.html.erb","line":15},{"original":"app/middleware/custom_middleware.rb:30:in `call'","path":"app/middleware/custom_middleware.rb","line":30}],"duration":10},{"id":2,"statement":"SELECT * FROM users WHERE id = 2","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10},{"id":3,"statement":"UPDATE users SET name  = 'Jack' WHERE id = 1","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10},{"id":4,"statement":"DELETE FROM users WHERE id = 1","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10},{"id":5,"statement":"DELETE FROM users WHERE id = 2","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":20},{"id":6,"statement":"SELECT * FROM users WHERE id = 3","backtrace":[{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15}],"duration":10}] */
  queries: QuerySchema[];
}

/** Aggregation of queries in terms of CRUD type and table */
export interface CrudAggregationSchema {
  /** @format int32 */
  id: number;
  /** CRUD type */
  type: 'CREATE' | 'READ' | 'UPDATE' | 'DELETE';
  /** Table name */
  table: string;
  /** Number of queries */
  count: number;
  /**
   * Total duration in milliseconds
   * @format float
   */
  duration: number;
  /** Corresponding query ids */
  queryIds: number[];
}

/** Aggregation of queries in terms of normalized sql statement */
export interface NormalizedAggregationSchema {
  /** @format int32 */
  id: number;
  /** Normalized sql statement */
  statement: string;
  /** Number of queries */
  count: number;
  /**
   * Total duration in milliseconds
   * @format float
   */
  duration: number;
  /** Corresponding query ids */
  queryIds: number[];
}

/** Query errored on parsing */
export interface ErroredQuerySchema {
  /** @format int32 */
  id: number;
  /** Error message */
  message: string;
  /** Sql statement */
  statement: string;
  /** Backtrace */
  backtrace: TraceInfoSchema[];
  /**
   * Query duration in milliseconds
   * @format float
   */
  duration: number;
}

/** Single sql query */
export interface QuerySchema {
  /** @format int32 */
  id: number;
  /** Sql statement */
  statement: string;
  /** Sql statement bind parameters */
  binds: string;
  /** Backtrace */
  backtrace: TraceInfoSchema[];
  /**
   * Query duration in milliseconds
   * @format float
   */
  duration: number;
}

/** Api request and response */
export interface ApiSchema {
  /**
   * Http status code
   * @example 200
   */
  status: string;
  /**
   * Http method
   * @example "GET"
   */
  method: string;
  /**
   * Full url
   * @example "https://example.com/api/v1/users"
   */
  url: string;
  /** @example [{"field":"User-Agent","value":"CustomServerClient/1.2.3"},{"field":"Content-Type","value":"application/json; charset=utf-8"},{"field":"Content-Length","value":123456},{"field":"Date","value":"Sat, 08 Oct 2023 00:00:00 GMT"}] */
  requestHeaders: HeaderSchema[];
  /** @example "{"id": 1, "name": "doggie", "photoUrls": ["url1", "url2"]}" */
  requestBody: string | null;
  /** @example [{"field":"Server","value":"TargetServer/4.3.2"},{"field":"Content-Type","value":"application/json; charset=utf-8"},{"field":"Content-Length","value":34567},{"field":"Date","value":"Sat, 08 Oct 2023 00:00:00 GMT"}] */
  responseHeaders: HeaderSchema[];
  /** @example "{"id": 1, "name": "doggie", "photoUrls": ["url1", "url2"]}" */
  responseBody: string;
  /**
   * Backtrace
   * @example [{"original":"app/controllers/users_controller.rb:25:in `show'","path":"app/controllers/users_controller.rb","line":25},{"original":"app/services/user_fetch_service.rb:15:in `find_by_id'","path":"app/services/user_fetch_service.rb","line":15},{"original":"app/models/user.rb:120:in `normalize_name'","path":"app/models/user.rb","line":120},{"original":"app/helpers/user_helper.rb:10:in `formatted_name'","path":"app/helpers/user_helper.rb","line":10}]
   */
  backtrace: TraceInfoSchema[];
}

/** @example {"field":"Content-Type","value":"application/json"} */
export interface HeaderSchema {
  /** Header field */
  field: string;
  /** Header value */
  value: string;
}

export interface TraceInfoSchema {
  /** Original trace info */
  original: string;
  /** File path */
  path: string;
  /**
   * Line number
   * @format int32
   */
  line: number;
}

export interface ErrorSchema {
  /**
   * Http status code
   * @format int32
   * @example 404
   */
  status: number;
  /**
   * Error message
   * @example "Not Found"
   */
  message: string;
}

export type QueryParamsType = Record<string | number, any>;
export type ResponseFormat = keyof Omit<Body, 'body' | 'bodyUsed'>;

export interface FullRequestParams extends Omit<RequestInit, 'body'> {
  /** set parameter to `true` for call `securityWorker` for this request */
  secure?: boolean;
  /** request path */
  path: string;
  /** content type of request body */
  type?: ContentType;
  /** query params */
  query?: QueryParamsType;
  /** format of response (i.e. response.json() -> format: "json") */
  format?: ResponseFormat;
  /** request body */
  body?: unknown;
  /** base url */
  baseUrl?: string;
  /** request cancellation token */
  cancelToken?: CancelToken;
}

export type RequestParams = Omit<FullRequestParams, 'body' | 'method' | 'query' | 'path'>;

export interface ApiConfig<SecurityDataType = unknown> {
  baseUrl?: string;
  baseApiParams?: Omit<RequestParams, 'baseUrl' | 'cancelToken' | 'signal'>;
  securityWorker?: (securityData: SecurityDataType | null) => Promise<RequestParams | void> | RequestParams | void;
  customFetch?: typeof fetch;
}

export interface HttpResponse<D extends unknown, E extends unknown = unknown> extends Response {
  data: D;
  error: E;
}

type CancelToken = Symbol | string | number;

export enum ContentType {
  Json = 'application/json',
  FormData = 'multipart/form-data',
  UrlEncoded = 'application/x-www-form-urlencoded',
  Text = 'text/plain',
}

export class HttpClient<SecurityDataType = unknown> {
  public baseUrl: string = '';
  private securityData: SecurityDataType | null = null;
  private securityWorker?: ApiConfig<SecurityDataType>['securityWorker'];
  private abortControllers = new Map<CancelToken, AbortController>();
  private customFetch = (...fetchParams: Parameters<typeof fetch>) => fetch(...fetchParams);

  private baseApiParams: RequestParams = {
    credentials: 'same-origin',
    headers: {},
    redirect: 'follow',
    referrerPolicy: 'no-referrer',
  };

  constructor(apiConfig: ApiConfig<SecurityDataType> = {}) {
    Object.assign(this, apiConfig);
  }

  public setSecurityData = (data: SecurityDataType | null) => {
    this.securityData = data;
  };

  protected encodeQueryParam(key: string, value: any) {
    const encodedKey = encodeURIComponent(key);
    return `${encodedKey}=${encodeURIComponent(typeof value === 'number' ? value : `${value}`)}`;
  }

  protected addQueryParam(query: QueryParamsType, key: string) {
    return this.encodeQueryParam(key, query[key]);
  }

  protected addArrayQueryParam(query: QueryParamsType, key: string) {
    const value = query[key];
    return value.map((v: any) => this.encodeQueryParam(key, v)).join('&');
  }

  protected toQueryString(rawQuery?: QueryParamsType): string {
    const query = rawQuery || {};
    const keys = Object.keys(query).filter((key) => 'undefined' !== typeof query[key]);
    return keys
      .map((key) => (Array.isArray(query[key]) ? this.addArrayQueryParam(query, key) : this.addQueryParam(query, key)))
      .join('&');
  }

  protected addQueryParams(rawQuery?: QueryParamsType): string {
    const queryString = this.toQueryString(rawQuery);
    return queryString ? `?${queryString}` : '';
  }

  private contentFormatters: Record<ContentType, (input: any) => any> = {
    [ContentType.Json]: (input: any) =>
      input !== null && (typeof input === 'object' || typeof input === 'string') ? JSON.stringify(input) : input,
    [ContentType.Text]: (input: any) => (input !== null && typeof input !== 'string' ? JSON.stringify(input) : input),
    [ContentType.FormData]: (input: any) =>
      Object.keys(input || {}).reduce((formData, key) => {
        const property = input[key];
        formData.append(
          key,
          property instanceof Blob
            ? property
            : typeof property === 'object' && property !== null
            ? JSON.stringify(property)
            : `${property}`,
        );
        return formData;
      }, new FormData()),
    [ContentType.UrlEncoded]: (input: any) => this.toQueryString(input),
  };

  protected mergeRequestParams(params1: RequestParams, params2?: RequestParams): RequestParams {
    return {
      ...this.baseApiParams,
      ...params1,
      ...(params2 || {}),
      headers: {
        ...(this.baseApiParams.headers || {}),
        ...(params1.headers || {}),
        ...((params2 && params2.headers) || {}),
      },
    };
  }

  protected createAbortSignal = (cancelToken: CancelToken): AbortSignal | undefined => {
    if (this.abortControllers.has(cancelToken)) {
      const abortController = this.abortControllers.get(cancelToken);
      if (abortController) {
        return abortController.signal;
      }
      return void 0;
    }

    const abortController = new AbortController();
    this.abortControllers.set(cancelToken, abortController);
    return abortController.signal;
  };

  public abortRequest = (cancelToken: CancelToken) => {
    const abortController = this.abortControllers.get(cancelToken);

    if (abortController) {
      abortController.abort();
      this.abortControllers.delete(cancelToken);
    }
  };

  public request = async <T = any, E = any>(
    { body, secure, path, type, query, format, baseUrl, cancelToken, ...params }: FullRequestParams,
  ): Promise<HttpResponse<T, E>> => {
    const secureParams =
      ((typeof secure === 'boolean' ? secure : this.baseApiParams.secure) &&
        this.securityWorker &&
        (await this.securityWorker(this.securityData))) ||
      {};
    const requestParams = this.mergeRequestParams(params, secureParams);
    const queryString = query && this.toQueryString(query);
    const payloadFormatter = this.contentFormatters[type || ContentType.Json];
    const responseFormat = format || requestParams.format;

    return this.customFetch(`${baseUrl || this.baseUrl || ''}${path}${queryString ? `?${queryString}` : ''}`, {
      ...requestParams,
      headers: {
        ...(requestParams.headers || {}),
        ...(type && type !== ContentType.FormData ? { 'Content-Type': type } : {}),
      },
      signal: (cancelToken ? this.createAbortSignal(cancelToken) : requestParams.signal) || null,
      body: typeof body === 'undefined' || body === null ? null : payloadFormatter(body),
    }).then(async (response) => {
      const r = response as HttpResponse<T, E>;
      r.data = null as unknown as T;
      r.error = null as unknown as E;

      const data = !responseFormat
        ? r
        : await response[responseFormat]()
            .then((data) => {
              if (r.ok) {
                r.data = data;
              } else {
                r.error = data;
              }
              return r;
            })
            .catch((e) => {
              r.error = e;
              return r;
            });

      if (cancelToken) {
        this.abortControllers.delete(cancelToken);
      }

      if (!response.ok) throw data;
      return data;
    });
  };
}

/**
 * @title Rack Dev Insight Internal API
 * @version 1.0.0
 * @license Apache 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)
 * @termsOfService https://github.com/takaebato/rack-dev-insight/blob/master/CODE_OF_CONDUCT.md
 * @externalDocs https://github.com/takaebato/rack-dev-insight
 * @contact <ebato.takahiro@gmail.com>
 *
 * This is an internal API specification for Rack Dev Insight.
 * It is used for communication between the Rack Dev Insight gem and Chrome extension.
 */
export class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
  rackDevInsightResults = {
    /**
     * @description Multiple status values can be provided with comma separated strings
     *
     * @tags Result
     * @name GetRackDevInsightResult
     * @summary Fetches a rack dev insight result by UUID
     * @request GET:/rack-dev-insight-results/{uuid}
     */
    getRackDevInsightResult: (uuid: string, params: RequestParams = {}) =>
      this.request<RackDevInsightResultSchema, ErrorSchema>({
        path: `/rack-dev-insight-results/${uuid}`,
        method: 'GET',
        format: 'json',
        ...params,
      }),
  };
}
