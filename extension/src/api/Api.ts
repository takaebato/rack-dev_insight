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
   * Result id
   * @format uuid
   */
  id: string;
  /**
   * Http status code
   * @format int32
   */
  status: number;
  /** Http method */
  method: string;
  /** Http path */
  path: string;
  /**
   * Request duration in milliseconds
   * @format float
   */
  duration: number;
  sql: SqlSchema;
  /** Api requests and responses */
  apis: ApiSchema[];
}

export interface SqlSchema {
  crudAggregations: CrudAggregationSchema[];
  normalizedAggregations: NormalizedAggregationSchema[];
  erroredQueries?: ErroredQuerySchema[];
  queries: QuerySchema[];
}

/** Aggregation of queries in terms of CRUD type and table */
export interface CrudAggregationSchema {
  /**
   * Crud aggregation id
   * @format int32
   */
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
  /**
   * Normalized aggregation id
   * @format int32
   */
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
  /**
   * Errored query id
   * @format int32
   */
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
  /**
   * Query id
   * @format int32
   */
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
   * @format int32
   */
  status: number;
  /** Http method */
  method: string;
  /** Full url */
  url: string;
  /**
   * Request duration in milliseconds
   * @format float
   */
  duration: number;
  /** Request headers */
  requestHeaders: HeaderSchema[];
  /** Request body */
  requestBody: string | null;
  /** Response headers */
  responseHeaders: HeaderSchema[];
  /** Response body */
  responseBody: string;
  /** Backtrace */
  backtrace: TraceInfoSchema[];
}

/** Http header */
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
   */
  status: number;
  /** Error message */
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
  public baseUrl: string = 'http://localhost:8081';
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
 * @termsOfService https://github.com/takaebato/rack-dev_insight/blob/master/CODE_OF_CONDUCT.md
 * @baseUrl http://localhost:8081
 * @externalDocs https://github.com/takaebato/rack-dev_insight
 * @contact <takahiro.ebato@gmail.com>
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
