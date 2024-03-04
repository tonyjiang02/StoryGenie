from fastapi import FastAPI
from openai import OpenAI
from pydantic import BaseModel

from typing import List

client = OpenAI()
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World"}

class Item(BaseModel):
    items: List[str]

@app.post("/createStory")
async def create_story(item: Item):
    themes = item.items
    themes_string = " ".join(themes)
    print(themes_string)
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are writing a book for a child. "},
            {"role": "user", "content": f"Compose a story about {themes_string}"}
        ]
    )
    print(completion.choices[0].message)
    split_lines = f"{completion.choices[0].message.content}".split('\n')
    split_lines = [x for x in split_lines if x!=""]
    return {"story": split_lines}
class ImageRequest(BaseModel):
    string: str

@app.post("dummyCreateStory")
async def dummy_create_story(item: Item):
    return {"story": ["Title: The Adventure of the Happy Family", "Once upon a time, in a cozy little cottage nestled in the heart of a beautiful meadow, lived a happy family. There was Papa Bear, Mama Bear, and their three little cubs – Bobby, Lily, and Rosie.", "Every morning, the family would wake up to the chirping of birds and the warm rays of the sun streaming through their window. Papa Bear would head out to gather berries for breakfast, while Mama Bear and the cubs set the table with their favorite honey and fresh flowers.", "After breakfast, the family would embark on all sorts of adventures together. They would explore the enchanted forest, climb the tallest mountains, and splash in the crystal-clear river. No matter where they went, they always stuck together, looking out for one another and sharing in the joy of each new discovery.", "In the evenings, they would gather around the fire pit outside their cottage, roasting marshmallows and sharing stories of their day. Each member of the family would take turns recounting their favorite moments, laughing and cuddling under the starlit sky.", "As the days passed, the bond between the family grew stronger and stronger. They learned to lean on each other in times of need, celebrate each other\'s successes, and most importantly, love one another unconditionally.", "One day, a fierce storm swept through the meadow, shaking their cottage and rattling their windows. But with their love and support for one another, the family stood strong, huddling together and weathering the storm as a united front.", "And so, the happy family lived happily ever after, cherishing each moment spent together and knowing that no matter what challenges life may bring, their love and unity would always see them through.", "The end."]}

string_to_image_dict = {}
stories = ["Title: The Adventure of the Happy Family", "Once upon a time, in a cozy little cottage nestled in the heart of a beautiful meadow, lived a happy family. There was Papa Bear, Mama Bear, and their three little cubs – Bobby, Lily, and Rosie.", "Every morning, the family would wake up to the chirping of birds and the warm rays of the sun streaming through their window. Papa Bear would head out to gather berries for breakfast, while Mama Bear and the cubs set the table with their favorite honey and fresh flowers.", "After breakfast, the family would embark on all sorts of adventures together. They would explore the enchanted forest, climb the tallest mountains, and splash in the crystal-clear river. No matter where they went, they always stuck together, looking out for one another and sharing in the joy of each new discovery.", "In the evenings, they would gather around the fire pit outside their cottage, roasting marshmallows and sharing stories of their day. Each member of the family would take turns recounting their favorite moments, laughing and cuddling under the starlit sky.", "As the days passed, the bond between the family grew stronger and stronger. They learned to lean on each other in times of need, celebrate each other\'s successes, and most importantly, love one another unconditionally.", "One day, a fierce storm swept through the meadow, shaking their cottage and rattling their windows. But with their love and support for one another, the family stood strong, huddling together and weathering the storm as a united front.", "And so, the happy family lived happily ever after, cherishing each moment spent together and knowing that no matter what challenges life may bring, their love and unity would always see them through.", "The end."]
images = ["https://oaidalleapiprodscus.blob.core.windows.net/private/org-QWNTTuiZHEZj7yvgzCIxH1R3/user-aneae4WFAtasBqTGpsiAzWcu/img-60BNKdU3RZPARviTIdrMMwYf.png?st=2024-03-04T01%3A25%3A25Z&se=2024-03-04T03%3A25%3A25Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-03T15%3A22%3A35Z&ske=2024-03-04T15%3A22%3A35Z&sks=b&skv=2021-08-06&sig=QtdCgL%2BMzAnbErJKuqQ4jDhdcqkHlboiD2KudMB04bQ%3D", "https://oaidalleapiprodscus.blob.core.windows.net/private/org-QWNTTuiZHEZj7yvgzCIxH1R3/user-aneae4WFAtasBqTGpsiAzWcu/img-4Nk6HTO7gTDEKL64JPYdohPC.png?st=2024-03-04T01%3A36%3A41Z&se=2024-03-04T03%3A36%3A41Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-03T15%3A25%3A09Z&ske=2024-03-04T15%3A25%3A09Z&sks=b&skv=2021-08-06&sig=sGDAeFB9kkKHpWKDI60FqhNGai5Sdp/5WXFIhODNDZo%3D", "https://ibb.co/fdKFZkK", "https://ibb.co/HgW1Rfp", ""]
for story in stories:
    string_to_image_dict[story] = 

@app.post("dummyCreateImage")
async def dummy_create_image(body: ImageRequest):
    return {"image_url"}


@app.post("/createImage")
async def create_image(body: ImageRequest):
    item = body.string
    response = client.images.generate(
        # model = "dall-e-2",
        model="dall-e-3",
        prompt = f"{item} in the style of a children's book",
        size="1024x1024",
        quality="standard",
        n=1
    )
    image_url = response.data[0].url
    return {"image_url": image_url}