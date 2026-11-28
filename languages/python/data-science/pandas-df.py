import pandas as pd

# https://stackoverflow.com/a/29956221
# seaborn_data = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/dataset_names.txt')
# for name in seaborn_data.iloc[:, 0]:
#     df = pd.read_csv(f'https://raw.githubusercontent.com/mwaskom/seaborn-data/master/{name}.csv')
#     print(name)
#     with pd.option_context('display.max_rows', None, 'display.max_columns', None):
#         print(df.sample(3))
#     print()
df = pd.read_csv(f'https://raw.githubusercontent.com/mwaskom/seaborn-data/master/taxis.csv')
print(df)


# https://pandas.pydata.org/docs/user_guide/timeseries.html
# TODO: time / date
def to_datetime(date):  # https://stackoverflow.com/a/27596917
    # stolen from Jehu Zepeda-Silva, apply at cellular level
    date = str(date).strip()
    if date.endswith("L") or date.isdigit():  # nnix timestamp in milliseconds
        return pd.to_datetime(int(date.rstrip("L")), unit="ms", utc=True)
    return pd.to_datetime(date, format="mixed", utc=True)  # automatically infer other date formats
    # df[col] = df[col].dt.tz_localize(datetime.timezone.utc)  # if need for specific timezone ever comes up later


# start from here
rows = [{'id': 0, 'a': 1, 'b': {'c': 1, 'd': 1, 'e': 1}}, {'id': 0, 'a': 2, 'b': {'c': 2, 'd': 2, 'e': 2}}, {'id': 1, 'a': 3, 'b': {'c': 3, 'd': 3, 'e': 3}}]
df = pd.DataFrame(rows)
print(df)

# inner join, merge, sql
# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.merge.html#pandas.DataFrame.merge
df1 = pd.DataFrame({"lkey": ["foo", "bar", "baz", "foo"], "value": [1, 2, 3, 5]})
df2 = pd.DataFrame({"rkey": ["foo", "bar", "qux", "xax"], "value": [5, 6, 7, 8]})
print(df1.merge(df2, how='inner', left_on="lkey", right_on="rkey", suffixes=("_df1", "_df2")))
print(df1.merge(df2, how='outer', left_on="lkey", right_on="rkey", suffixes=("_df1", "_df2")))

# explode a dictionary to multiple series
# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.json_normalize.html
df_explode = pd.json_normalize(df['b'])
print(df_explode)
df = pd.concat([df, df_explode], axis=1)  # glue column to column
print(df)
