import { Client } from "https://deno.land/x/mysql@v2.12.1/mod.ts";
import { FieldInfo } from "https://deno.land/x/mysql@v2.12.1/src/packets/parsers/result.ts";
import { format } from "https://deno.land/std@0.202.0/datetime/mod.ts";

export const mapValues = <T, U>(
  obj: { [key: string]: T },
  to: (x: T, key: string) => U,
): { [key: string]: U } =>
  Object.fromEntries(
    Object.entries(obj).map(([key, value]) => [key, to(value, key)]),
  );

export const keyBy = <T>(
  values: T[],
  toKey: (t: T) => string,
): { [key: string]: T } => {
  const indexing: { [key: string]: T } = {};
  for (const value of values) {
    const key = toKey(value);
    indexing[key] = value;
  }
  return indexing;
};

type RowValue = string | number | boolean | Date | undefined | null;
type Row = { [columnName: string]: RowValue };

function normalize(row: Row, fieldInfos: FieldInfo[]): Row {
  const fieldInfoByName = keyBy(fieldInfos, (fi) => fi.name);
  return mapValues(row, (v, k) => {
    if (v == null) {
      return v;
    }

    switch (fieldInfoByName[k].fieldType) {
      case 10: // date は 2024-12-03 形式に
        return format(v as Date, "yyyy-MM-dd");
      case 12: // date は 2024-12-03 11:35:00 形式に
        return format(v as Date, "yyyy-MM-dd HH:mm:ss");
      default:
        return v;
    }
  });
}
async function handler(request: Request): Promise<Response> {
  const url = new URL(request.url);

  const table = url.searchParams.get("table")!;

  const client = await new Client().connect({
    hostname: "db",
    port: 3306,
    username: "user",
    password: "password",
    db: "mydb",
  });

  const { rows, fields } = await client.execute(`select * from ??`, [table]);
  if (!rows || !fields) {
    return Response.error();
  }

  return Response.json(rows.map((x) => normalize(x, fields)));
}

Deno.serve(handler);
