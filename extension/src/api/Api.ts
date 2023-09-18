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

export interface RackAnalyzerResultSchema {
  /**
   * @format int64
   * @example 123
   */
  id: number;
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
   * @format int32
   * @example 10
   */
  duration: number;
  sql: SqlSchema;
  /** Api requests and responses */
  apis?: ApiSchema[];
}

export interface SqlSchema {
  /** @example [{"type":"CREATE","table":"users","count":1,"duration":10,"queryIds":[1]},{"type":"READ","table":"users","count":1,"duration":10,"queryIds":[2]},{"type":"UPDATE","table":"users","count":1,"duration":10,"queryIds":[3]},{"type":"DELETE","table":"users","count":2,"duration":10,"queryIds":[4,5]}] */
  crudAggregations: CrudAggregationSchema[];
  /** @example [{"statement":"INSERT INTO users (id, name) VALUES (?, ?)","count":1,"duration":10,"queryIds":[1]},{"statement":"SELECT * FROM users WHERE id = ?","count":1,"duration":10,"queryIds":[2]},{"statement":"UPDATE users SET name = ? WHERE id = ?","count":1,"duration":10,"queryIds":[3]},{"statement":"DELETE FROM users WHERE id = ?","count":2,"duration":10,"queryIds":[4,5]}] */
  normalizedAggregations: NormalizedAggregationSchema[];
  /** @example [{"message":"Parse error","queryId":6}] */
  erroredQueries?: ErroredQuerySchema[];
  /** @example [{"id":1,"statement":"INSERT INTO users (id, name) VALUES (1, 'John')","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10},{"id":2,"statement":"SELECT * FROM users WHERE id = 2","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10},{"id":3,"statement":"UPDATE users SET name  = 'Jack' WHERE id = 1","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10},{"id":4,"statement":"DELETE FROM users WHERE id = 1","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10},{"id":5,"statement":"DELETE FROM users WHERE id = 2","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10},{"id":6,"statement":"SELECT * FROM users WHERE id = 3","backtrace":["app/models/user.rb:1","app/controllers/users_controller.rb:1"],"duration":10}] */
  queries: QuerySchema[];
}

/** Aggregation of queries in terms of CRUD type and table */
export interface CrudAggregationSchema {
  /** CRUD type */
  type: 'CREATE' | 'READ' | 'UPDATE' | 'DELETE';
  /** Table name */
  table: string;
  /** Number of queries */
  count: number;
  /** Total duration in milliseconds */
  duration: number;
  /** Corresponding query ids */
  queryIds: number[];
}

/** Aggregation of queries in terms of normalized sql statement */
export interface NormalizedAggregationSchema {
  /** Normalized sql statement */
  statement: string;
  /** Number of queries */
  count: number;
  /** Total duration in milliseconds */
  duration: number;
  /** Corresponding query ids */
  queryIds: number[];
}

/** Query errored on parsing */
export interface ErroredQuerySchema {
  /** Error message */
  message: string;
  queryId: number;
}

/** Single sql query */
export interface QuerySchema {
  /** @format int32 */
  id: number;
  /** Sql statement */
  statement: string;
  /** Backtrace */
  backtrace: string[];
  /** Query duration in milliseconds */
  duration: number;
}

/** Api request and response */
export interface ApiSchema {
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
   * Full url
   * @example "https://example.com/api/v1/pets"
   */
  url?: string;
  /** @example [{"field":"Content-Type","value":"application/json"},{"field":"Content-Length","value":123},{"field":"Referer","value":"https://example.com"}] */
  requestHeaders: HeaderSchema[];
  /** @example "{"id": 1, "name": "doggie", "photoUrls": ["url1", "url2"]}" */
  requestBody: string;
  /** @example [{"field":"Content-Type","value":"application/json"},{"field":"Content-Length","value":123},{"field":"Server","value":"nginx/1.16.0"}] */
  responseHeaders: HeaderSchema[];
  /** @example "{"id": 1, "name": "doggie", "photoUrls": ["url1", "url2"]}" */
  responseBody: string;
}

/** @example {"field":"Content-Type","value":"application/json"} */
export interface HeaderSchema {
  field?: string;
  value?: string;
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
  public baseUrl: string = 'https://petstore3.swagger.io/api/v3';
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

  public request = async <T = any, E = any>({
    body,
    secure,
    path,
    type,
    query,
    format,
    baseUrl,
    cancelToken,
    ...params
  }: FullRequestParams): Promise<HttpResponse<T, E>> => {
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
 * @title Rack Analyzer Internal API
 * @version 1.0.11
 * @license Apache 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)
 * @termsOfService http://swagger.io/terms/
 * @baseUrl https://petstore3.swagger.io/api/v3
 * @externalDocs http://swagger.io
 * @contact <apiteam@swagger.io>
 *
 * This is a sample Pet Store Server based on the OpenAPI 3.0 specification.  You can find out more about
 * Swagger at [https://swagger.io](https://swagger.io). In the third iteration of the pet store, we've switched to the design first approach!
 * You can now help us improve the API whether it's by making changes to the definition itself or to the code.
 * That way, with time, we can improve the API in general, and expose some of the new features in OAS3.
 *
 * _If you're looking for the Swagger 2.0/OAS 2.0 version of Petstore, then click [here](https://editor.swagger.io/?url=https://petstore.swagger.io/v2/swagger.yaml). Alternatively, you can load via the `Edit > Load Petstore OAS 2.0` menu option!_
 *
 * Some useful links:
 * - [The Pet Store repository](https://github.com/swagger-api/swagger-petstore)
 * - [The source API definition for the Pet Store](https://github.com/swagger-api/swagger-petstore/blob/master/src/main/resources/openapi.yaml)
 */
export class Api<SecurityDataType extends unknown> extends HttpClient<SecurityDataType> {
  rackAnalyzerResults = {
    /**
     * @description Multiple status values can be provided with comma separated strings
     *
     * @tags Result
     * @name GetRackAnalyzerResult
     * @summary Fetches a rack analyzer result by UUID
     * @request GET:/rack-analyzer-results/{uuid}
     */
    getRackAnalyzerResult: (uuid: string, params: RequestParams = {}) =>
      this.request<RackAnalyzerResultSchema, void>({
        path: `/rack-analyzer-results/${uuid}`,
        method: 'GET',
        format: 'json',
        ...params,
      }),
  };
}
