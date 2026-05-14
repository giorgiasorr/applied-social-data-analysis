import re
from collections import Counter
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from sklearn.feature_extraction.text import ENGLISH_STOP_WORDS

# -----------------------
# CONFIG
# -----------------------

BASE_DIR = Path(".")
DATA_PATH = BASE_DIR / "raw_social_media_sample.xlsx"  
OUTPUT_DIR = BASE_DIR / "figures"

SAVE_FIGURES = True

plt.style.use("ggplot")

# Accessible color palette (Okabe-Ito)
OKABE_ITO = {
    "blue": "#0072B2",
    "orange": "#D55E00",
    "green": "#009E73",
    "yellow": "#F0E442",
    "purple": "#CC79A7",
    "light_blue": "#56B4E9",
    "grey": "#999999",
}

# -----------------------
# PREPROCESSING
# -----------------------


def load_data(path):
    df = pd.read_excel(path)
    df.columns = df.columns.str.strip()
    return df


def preprocess_data(df):
    df = df.rename(columns={"type of actor": "actor_type", "date and time": "datetime"})

    df["datetime"] = pd.to_datetime(df["datetime"])
    df["date"] = df["datetime"].dt.date
    df["hour"] = df["datetime"].dt.hour
    df["day_name"] = df["datetime"].dt.day_name()

    days = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
    ]
    df["day_name"] = pd.Categorical(df["day_name"], categories=days, ordered=True)

    return df, days


# -----------------------
# TEXT PROCESSING
# -----------------------


def preprocess_words(text_series):
    text = " ".join(text_series).lower()
    text = re.sub(r"[^\w\s]", "", text)
    words = text.split()

    return [w for w in words if w not in ENGLISH_STOP_WORDS and len(w) > 2]


# -----------------------
# ANALYSIS
# -----------------------


def detect_low_info(df):
    df["is_low_info"] = (
        df["post"]
        .str.lower()
        .str.contains(r"\bokay\b|\bnote\b|\bnightmare\b", na=False)
    )

    return df.groupby("actor_type")["is_low_info"].mean().sort_values(ascending=False)


def detect_coordination(df):
    coordination = df.groupby("post").agg(
        n_users=("username", "nunique"),
        time_min=("datetime", "min"),
        time_max=("datetime", "max"),
    )

    coordination["time_span_minutes"] = (
        coordination["time_max"] - coordination["time_min"]
    ).dt.total_seconds() / 60

    coordinated = coordination[
        (coordination["n_users"] > 1) & (coordination["time_span_minutes"] <= 60)
    ].sort_values(["n_users", "time_span_minutes"], ascending=[False, True])

    return coordination, coordinated


def descriptive_stats(df, days):
    top_users = df["username"].value_counts().head(5)
    actor_counts = df["actor_type"].value_counts()

    posts_per_day = df["date"].value_counts().sort_index()
    posts_per_day_name = df.groupby("day_name", observed=False).size().reindex(days)
    posts_per_hour = df["hour"].value_counts().sort_index()

    actor_hour = df.groupby(["actor_type", "hour"]).size().unstack(fill_value=0)
    actor_hour = actor_hour.reindex(columns=range(24), fill_value=0)

    return {
        "top_users": top_users,
        "actor_counts": actor_counts,
        "posts_per_day": posts_per_day,
        "posts_per_day_name": posts_per_day_name,
        "posts_per_hour": posts_per_hour,
        "actor_hour": actor_hour,
    }


def text_analysis(df):
    all_words = preprocess_words(df["post"])
    word_counts = Counter(all_words)

    actor_keywords = df.groupby("actor_type")["post"].apply(
        lambda x: Counter(preprocess_words(x)).most_common(10)
    )

    return word_counts, actor_keywords


# -----------------------
# VISUALIZATION
# -----------------------


def save_plot(fig_name):
    if SAVE_FIGURES:
        plt.savefig(OUTPUT_DIR / fig_name)


def plot_results(stats, low_info_actor_share):
    OUTPUT_DIR.mkdir(exist_ok=True)

    BLUE = OKABE_ITO["blue"]

    # Posts per day
    plt.figure(figsize=(8, 5))
    stats["posts_per_day"].plot(marker="o", color=BLUE)
    plt.title("Posts per Day")
    plt.xlabel("Date")
    plt.ylabel("Number of Posts")
    plt.xticks(rotation=45)
    plt.tight_layout()
    save_plot("posts_per_day.png")
    plt.close()

    # Posts per weekday
    plt.figure(figsize=(8, 5))
    stats["posts_per_day_name"].plot(kind="bar", color=BLUE)
    plt.title("Posts by Day of Week")
    plt.tight_layout()
    save_plot("posts_per_weekday.png")
    plt.close()

    # Posts per hour
    plt.figure(figsize=(8, 5))
    stats["posts_per_hour"].plot(kind="bar", color=BLUE)
    plt.title("Posts by Hour")
    plt.tight_layout()
    save_plot("posts_per_hour.png")
    plt.close()

    # Top users
    plt.figure(figsize=(8, 5))
    stats["top_users"].plot(kind="barh", color=OKABE_ITO["purple"])
    plt.title("Top 5 Users")
    plt.tight_layout()
    save_plot("top_users.png")
    plt.close()

    # Actor types
    plt.figure(figsize=(8, 5))
    stats["actor_counts"].plot(kind="barh", color=OKABE_ITO["green"])
    plt.title("Actor Types")
    plt.tight_layout()
    save_plot("actor_types.png")
    plt.close()

    # Heatmap (keep viridis — it's already accessible)
    plt.figure(figsize=(10, 5))
    sns.heatmap(stats["actor_hour"], cmap="viridis")
    plt.title("Activity by Actor and Hour")
    plt.tight_layout()
    save_plot("actor_hour_heatmap.png")
    plt.close()

    # Low-info content
    plt.figure(figsize=(8, 5))
    low_info_actor_share.sort_values().plot(kind="barh", color=OKABE_ITO["grey"])
    plt.title("Low-Information Content Share")
    plt.tight_layout()
    save_plot("low_info.png")
    plt.close()


# -----------------------
# MAIN
# -----------------------


def main():
    print("Loading data...")
    df = load_data(DATA_PATH)

    df, days = preprocess_data(df)

    print("Running analysis...")

    low_info_actor_share = detect_low_info(df)
    coordination, coordinated = detect_coordination(df)
    stats = descriptive_stats(df, days)
    word_counts, actor_keywords = text_analysis(df)

    # Key outputs only
    print("\nTop users:\n", stats["top_users"])
    print("\nActor distribution:\n", stats["actor_counts"])
    print("\nMost active day:", stats["posts_per_day"].idxmax())
    print("Peak hour:", stats["posts_per_hour"].idxmax())

    print("\nCoordination cases detected:", len(coordinated))

    print("\nTop words:", word_counts.most_common(10))

    print("\nSaving visualisations...")
    plot_results(stats, low_info_actor_share)

    print("\nDone.")


if __name__ == "__main__":
    main()
