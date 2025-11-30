# CSV Import Format Guide

## File Format

The CSV file must have the following columns in this exact order:

```
habit_id,title,description,created_at,log_date
```

## Column Descriptions

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| `habit_id` | Integer | Yes | Unique identifier for grouping habit logs | `1` |
| `title` | String | Yes | Name of the habit | `Morning Exercise` |
| `description` | String | Yes | Description of the habit | `30 minutes of cardio` |
| `created_at` | ISO 8601 DateTime | Yes | When the habit was created | `2024-01-01T08:00:00.000` |
| `log_date` | ISO 8601 DateTime | No | When the habit was completed (empty if no logs) | `2024-01-01T08:30:00.000` |

## Rules

1. **Header Row**: First row must contain column names exactly as shown above
2. **Multiple Logs**: Same habit can appear on multiple rows with different `log_date` values
3. **No Logs**: If a habit has no completion logs, leave `log_date` empty
4. **Grouping**: Rows with the same `habit_id` are treated as the same habit
5. **Date Format**: Use ISO 8601 format: `YYYY-MM-DDTHH:mm:ss.SSS`

## Example

```csv
habit_id,title,description,created_at,log_date
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-01T08:30:00.000
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-02T08:30:00.000
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-03T08:30:00.000
2,Read Books,Read for 20 minutes,2024-01-01T09:00:00.000,2024-01-01T21:00:00.000
2,Read Books,Read for 20 minutes,2024-01-01T09:00:00.000,2024-01-02T21:00:00.000
3,Drink Water,8 glasses per day,2024-01-01T10:00:00.000,
```

This example creates:
- **Habit 1**: "Morning Exercise" with 3 completion logs
- **Habit 2**: "Read Books" with 2 completion logs
- **Habit 3**: "Drink Water" with no completion logs

## Sample File

A sample CSV file is included in the app at `assets/sample_habits_import.csv` for reference.

## Import Steps

1. Go to **Settings** page
2. Tap **Import from CSV**
3. Select your CSV file
4. Wait for import confirmation
5. Check **Habits** page to see imported habits
